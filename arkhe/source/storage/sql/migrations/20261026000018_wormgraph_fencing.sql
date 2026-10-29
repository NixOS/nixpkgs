-- Tenant-wide because wormgraph_records has no stream column. One common
-- PostgreSQL authority must be used by every writer; independent copies of this
-- table are NOT a cross-cloud fence. Existing tenants opt in through admin setup.
CREATE TABLE wormgraph_writer_fence (
  tenant_id text PRIMARY KEY,
  epoch bigint NOT NULL CHECK (epoch > 0),
  owner_login name NOT NULL
);
ALTER TABLE wormgraph_records ADD COLUMN writer_epoch bigint CHECK(writer_epoch > 0);
ALTER TABLE work_objects ADD COLUMN writer_epoch bigint CHECK(writer_epoch > 0);
ALTER TABLE mmr_checkpoints ADD COLUMN writer_epoch bigint CHECK(writer_epoch > 0);
ALTER TABLE memo_observation_packages ADD COLUMN writer_epoch bigint CHECK(writer_epoch > 0);
REVOKE ALL ON wormgraph_writer_fence FROM PUBLIC, arkhe_append, arkhe_read;
CREATE FUNCTION arkhe_writer_epoch(tenant text) RETURNS bigint
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public AS $$
DECLARE result bigint;
BEGIN
  IF tenant <> public.arkhe_assert_tenant() THEN RAISE EXCEPTION 'tenant mismatch'; END IF;
  SELECT epoch INTO result FROM public.wormgraph_writer_fence WHERE tenant_id=tenant;
  IF result IS NULL THEN RAISE EXCEPTION 'fencing not enabled'; END IF;
  RETURN result;
END $$;
REVOKE ALL ON FUNCTION arkhe_writer_epoch(text) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION arkhe_writer_epoch(text) TO arkhe_read, arkhe_append;

CREATE FUNCTION arkhe_check_writer_fence() RETURNS trigger
LANGUAGE plpgsql SECURITY DEFINER SET search_path = pg_catalog, public AS $$
DECLARE fence public.wormgraph_writer_fence%ROWTYPE;
BEGIN
  -- The shared lock lasts until commit/rollback. Promotion's UPDATE waits for
  -- all admitted old writes, then excludes every subsequent old write.
  SELECT * INTO fence FROM public.wormgraph_writer_fence
    WHERE tenant_id = NEW.tenant_id FOR SHARE;
  IF FOUND AND (
    fence.owner_login <> session_user
    OR nullif(current_setting('arkhe.writer_epoch', true), '') IS NULL
    OR current_setting('arkhe.writer_epoch', true)::bigint <> fence.epoch
  ) THEN
    RAISE EXCEPTION 'stale or unauthorized WormGraph writer' USING ERRCODE='42501';
  END IF;
  NEW.writer_epoch := CASE WHEN fence.epoch IS NULL THEN NULL ELSE fence.epoch END;
  RETURN NEW;
END $$;
REVOKE ALL ON FUNCTION arkhe_check_writer_fence() FROM PUBLIC;
DO $$
DECLARE t text;
BEGIN
  FOREACH t IN ARRAY ARRAY['wormgraph_records','work_objects','mmr_checkpoints','memo_observation_packages'] LOOP
    EXECUTE format('CREATE TRIGGER %I_writer_fence BEFORE INSERT ON %I FOR EACH ROW EXECUTE FUNCTION arkhe_check_writer_fence()', t, t);
  END LOOP;
END $$;
