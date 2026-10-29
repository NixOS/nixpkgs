use arkhe_runtime::preview::{
    admit_preview,
    dispatch::{Completion, PreviewQueue},
    executor::{self, read_json, ExecutorConfig},
};
use arkhe_wormgraph::postgres::PgWormGraph;
use clap::Parser;
use std::{
    path::PathBuf,
    sync::{
        atomic::{AtomicBool, Ordering},
        Arc,
    },
    time::{Duration, SystemTime, UNIX_EPOCH},
};
#[derive(Parser)]
#[command(about = "Process at most one signed preview using a qualified Podman executor")]
struct Args {
    #[arg(long)]
    executor: PathBuf,
}
fn now() -> i64 {
    SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .map(|v| v.as_secs() as i64)
        .unwrap_or(-1)
}
#[tokio::main]
async fn main() {
    if let Err(e) = run().await {
        eprintln!("preview worker: {e}");
        std::process::exit(1)
    }
}
async fn run() -> Result<(), String> {
    let args = Args::parse();
    let config: ExecutorConfig = read_json(&args.executor)?;
    let trust: arkhe_runtime::preview::PreviewTrust = read_json(&config.trust_file)?;
    let url = std::env::var("ARKHE_PREVIEW_DATABASE_URL")
        .map_err(|_| "ARKHE_PREVIEW_DATABASE_URL required")?;
    let queue = Arc::new(PreviewQueue::connect(&url, &trust.tenant).await?);
    let Some(lease) = queue.claim_for(&trust.requested_by, 30).await? else {
        println!("{{\"state\":\"IDLE\"}}");
        return Ok(());
    };
    let lease = Arc::new(lease);
    let cancel = Arc::new(AtomicBool::new(false));
    let done = Arc::new(AtomicBool::new(false));
    let task = {
        let queue = queue.clone();
        let lease = lease.clone();
        let cancel = cancel.clone();
        let done = done.clone();
        let config = config.clone();
        tokio::spawn(async move {
            while !done.load(Ordering::SeqCst) {
                tokio::time::sleep(Duration::from_secs(5)).await;
                if done.load(Ordering::SeqCst) {
                    break;
                }
                let active = read_json::<arkhe_runtime::preview::PreviewTrust>(&config.trust_file)
                    .is_ok_and(|t| {
                        !t.emergency_stop
                            && t.digest() == lease.request.review.policy_digest
                            && t.policy_digest == t.digest()
                    });
                let qualification = read_json::<executor::Qualification>(&config.qualification)
                    .is_ok_and(|q| {
                        q.verify(
                            &lease.request.spec,
                            &config.qualification_key,
                            q.engine_identity,
                            q.executor_digest,
                            now(),
                        )
                        .is_ok()
                    });
                let authority = if let Some(policy) = &config.authority {
                    arkhe_runtime::preview::authority::admit(
                        policy,
                        config.qualification_key,
                        &lease.request.spec,
                        now(),
                    )
                    .await
                    .is_ok()
                } else {
                    false
                };
                if !active
                    || !qualification
                    || !authority
                    || !queue.heartbeat(&lease, 30).await.unwrap_or(false)
                {
                    cancel.store(true, Ordering::SeqCst);
                    break;
                }
            }
        })
    };
    let result: Result<&str, String> = async {
        let graph = PgWormGraph::connect(&url, &trust.tenant)
            .await
            .map_err(|_| "preview evidence unavailable")?;
        if let Err(e) = admit_preview(lease.request.clone(), &trust, &graph, now()).await {
            if !queue.finish(&lease, Completion::Failed(e)).await? {
                return Err("lease lost while recording rejection".into());
            }
            return Ok("FAILED");
        }
        let prepared = match executor::prepare(config.clone(), &lease.request.spec, now()).await {
            Ok(p) => p,
            Err(e) => {
                if !queue.finish(&lease, Completion::Retry(e)).await? {
                    return Err("lease lost while recording preflight failure".into());
                }
                return Ok("RETRY_OR_DEAD");
            }
        };
        // Reload current policy and signatures immediately before dispatch.
        let active = read_json(&config.trust_file)?;
        admit_preview(lease.request.clone(), &active, &graph, now()).await?;
        executor::revalidate(&prepared, &active, now()).await?;
        if cancel.load(Ordering::SeqCst) || !queue.start(&lease).await? {
            return Err("lease lost before dispatch".into());
        }
        let outcome = executor::execute(&prepared, cancel.clone()).await;
        let (state, result) = match outcome {
            Ok(receipt) => {
                let current: Result<(), String> = async {
                    if cancel.load(Ordering::SeqCst) {
                        return Err("lease cancelled".into());
                    }
                    let active = read_json(&config.trust_file)?;
                    admit_preview(lease.request.clone(), &active, &graph, now()).await?;
                    executor::revalidate(&prepared, &active, now()).await
                }
                .await;
                if current.is_ok() {
                    ("SUCCEEDED", Completion::Succeeded(receipt))
                } else {
                    (
                        "UNKNOWN",
                        Completion::Unknown(
                            "active admission or qualification lost before completion".into(),
                        ),
                    )
                }
            }
            Err(e) => ("UNKNOWN", Completion::Unknown(e)),
        };
        if !queue.finish(&lease, result).await? {
            return Err("fenced completion rejected; reconcile UNKNOWN state".into());
        }
        Ok(state)
    }
    .await;
    done.store(true, Ordering::SeqCst);
    task.abort();
    let _ = task.await;
    println!(
        "{}",
        serde_json::json!({"operation_id":lease.request.intent.operation_id().to_hex(),"fence":lease.fence,"attempts":lease.attempts,"state":result?,"production_release":false})
    );
    Ok(())
}
