-- Cloud schema: tenant ids in Arkhe are text, not UUID references to a tenants table.
-- The local arkhe-intra adapter uses SQLite; this migration does not bridge it to PostgreSQL.
CREATE TABLE tenant_billing (
  tenant_id text PRIMARY KEY,
  stripe_customer_id text UNIQUE NOT NULL,
  stripe_subscription_id text UNIQUE,
  plan_tier text CHECK (plan_tier IN ('starter','pro','enterprise')),
  status text NOT NULL DEFAULT 'incomplete' CHECK
    (status IN ('incomplete','incomplete_expired','trialing','active','past_due','canceled','unpaid','paused')),
  updated_at timestamptz NOT NULL DEFAULT clock_timestamp()
);
ALTER TABLE tenant_billing ENABLE ROW LEVEL SECURITY;
ALTER TABLE tenant_billing FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation_billing ON tenant_billing
  USING (tenant_id = arkhe_assert_tenant())
  WITH CHECK (tenant_id = arkhe_assert_tenant());
-- Runtime privileges are deliberately not granted: only a separately scoped billing
-- worker should mutate payment state. Never grant arbitrary clients UPDATE here.
