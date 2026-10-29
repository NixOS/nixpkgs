//! Explicit local admission CLI. Never invokes an executor or accepts private keys.
use arkhe_runtime::preview::{
    admit_preview, dispatch::PreviewQueue, enqueue_preview, executor::read_json, review_preview,
    PreviewRequest, PreviewTrust,
};
use arkhe_wormgraph::postgres::PgWormGraph;
use clap::Parser;
use std::{
    path::PathBuf,
    time::{SystemTime, UNIX_EPOCH},
};

#[derive(Parser)]
#[command(about = "Verify signed preview evidence and optionally enqueue it; no execution")]
struct Args {
    /// Trusted operator-owned configuration; never model-generated.
    #[arg(long)]
    trust: PathBuf,
    #[arg(long)]
    request: Option<PathBuf>,
    /// Commit admission and pending outbox entry atomically. Default is verification only.
    #[arg(long)]
    enqueue: bool,
    #[arg(long, conflicts_with_all=["enqueue","status"])]
    review_payload: bool,
    #[arg(long, conflicts_with_all=["enqueue","review_payload"])]
    status: bool,
    #[arg(long, requires = "status")]
    operation: Option<String>,
}
#[tokio::main]
async fn main() {
    if let Err(error) = run().await {
        eprintln!("preview rejected: {error}");
        std::process::exit(1);
    }
}
async fn run() -> Result<(), String> {
    let args = Args::parse();
    let trust: PreviewTrust = read_json(&args.trust)?;
    let url = std::env::var("ARKHE_PREVIEW_DATABASE_URL")
        .map_err(|_| "ARKHE_PREVIEW_DATABASE_URL required")?;
    if args.status {
        let raw = hex::decode(args.operation.ok_or("--operation required with --status")?)
            .map_err(|_| "invalid operation")?;
        let op = arkhe_core::Digest32(raw.try_into().map_err(|_| "invalid operation length")?);
        let queue = PreviewQueue::connect(&url, &trust.tenant).await?;
        println!(
            "{}",
            serde_json::json!({"dispatch":queue.status(&trust.requested_by,op).await?})
        );
        return Ok(());
    }
    let request: PreviewRequest = read_json(&args.request.ok_or("--request required")?)?;
    // Refuses administrative/RLS-bypass credentials. Database errors are deliberately
    // not printed: a driver error can contain deployment/connection details.
    let graph = PgWormGraph::connect(&url, &trust.tenant)
        .await
        .map_err(|_| "preview evidence database unavailable or role rejected")?;
    let now = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .map_err(|_| "invalid clock")?
        .as_secs();
    if args.review_payload {
        let challenge = review_preview(
            request,
            &trust,
            &graph,
            i64::try_from(now).map_err(|_| "clock overflow")?,
        )
        .await?;
        println!(
            "{}",
            serde_json::to_string(&challenge).map_err(|_| "challenge encoding failed")?
        );
        return Ok(());
    }
    let admitted = admit_preview(
        request,
        &trust,
        &graph,
        i64::try_from(now).map_err(|_| "clock overflow")?,
    )
    .await?;
    let bundle = if args.enqueue {
        let pool = sqlx::postgres::PgPoolOptions::new()
            .max_connections(1)
            .connect(&url)
            .await
            .map_err(|_| "preview queue database unavailable")?;
        let mut tx = pool
            .begin()
            .await
            .map_err(|_| "preview transaction unavailable")?;
        sqlx::query("SET LOCAL ROLE arkhe_preview_enqueue")
            .execute(&mut *tx)
            .await
            .map_err(|_| "preview enqueue role unavailable")?;
        arkhe_sql::tenant::set_tenant(&mut tx, &trust.tenant)
            .await
            .map_err(|_| "preview tenant unavailable")?;
        let bundle = enqueue_preview(&mut tx, &admitted)
            .await
            .map_err(|_| "preview enqueue rejected; transaction rolled back")?;
        tx.commit()
            .await
            .map_err(|_| "preview commit failed; reconcile before retry")?;
        Some(bundle.to_hex())
    } else {
        None
    };
    println!(
        "{}",
        serde_json::json!({"status": if args.enqueue {"ADMITTED_PENDING"} else {"VERIFIED_ONLY"},
        "operation_id": admitted.operation_id().to_hex(), "authorization_ref": admitted.authorization_ref().to_hex(),
        "bundle_digest": bundle, "execution_authority": false, "executed": false,
        "scope": "preview admission v1; not a WormGraph inclusion receipt or production release"})
    );
    Ok(())
}
