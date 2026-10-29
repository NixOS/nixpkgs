CREATE MATERIALIZED VIEW tenant_usage_daily AS
SELECT tenant_id,
       date_trunc('day', started_at) AS day,
       count(*) AS operations,
       sum(estimated_cost_usd) AS cost
FROM usage_events
GROUP BY tenant_id, date_trunc('day', started_at);

CREATE UNIQUE INDEX tenant_usage_daily_pk
  ON tenant_usage_daily (tenant_id, day);

CREATE MATERIALIZED VIEW verification_outcomes AS
SELECT tenant_id, policy_digest, result, count(*) AS n
FROM verification_records
GROUP BY tenant_id, policy_digest, result;

REVOKE ALL ON tenant_usage_daily, verification_outcomes FROM PUBLIC;
GRANT SELECT ON tenant_usage_daily, verification_outcomes TO arkhe_read;
