//! Read-only escalation queue/Prometheus gauge. Never retries upstream actions.
use arkhe_bugbounty::postgres::PgOperations;
#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = std::env::var("DATABASE_URL")?;
    let tenant = std::env::var("ARKHE_TENANT_ID")?;
    let operations = PgOperations::connect(&url, &tenant).await?;
    match std::env::args().nth(1).as_deref() {
        Some("list") => println!(
            "{}",
            serde_json::to_string_pretty(&operations.reconciliation_queue(300).await?)?
        ),
        Some("metrics") => print!("{}", operations.reconciliation_metrics(300).await?),
        _ => return Err("usage: manual_reconciliation list|metrics".into()),
    }
    Ok(())
}
