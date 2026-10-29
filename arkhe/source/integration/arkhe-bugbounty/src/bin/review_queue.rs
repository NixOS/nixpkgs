//! Read-only listing or explicit historical seeding. No human approval or external write.
use arkhe_bugbounty::{
    review::{FileReviewQueue, ReviewItem, ReviewPolicy, ReviewRouter, ReviewSignals},
    ReportDetails, Severity, State, TriageParams,
};
use arkhe_core::{
    work::{RequestIdentity, WorkIntent, WorkIntentType},
    Digest32,
};
use std::path::PathBuf;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<_> = std::env::args().skip(1).collect();
    if args.len() < 2 {
        return Err(
            "usage: review_queue list|metrics <queue.json> | shadow <queue.json> <candidate-policy.json> | seed-origin <queue.json> <run-01-directory>"
                .into(),
        );
    }
    let queue = FileReviewQueue::new(&args[1]);
    match args[0].as_str() {
        "list" if args.len() == 2 => (),
        "metrics" if args.len() == 2 => {
            println!("{}", serde_json::to_string_pretty(&queue.metrics()?)?);
            return Ok(());
        }
        "shadow" if args.len() == 3 => {
            let policy: ReviewPolicy = serde_json::from_slice(&std::fs::read(&args[2])?)?;
            let candidate = ReviewRouter::new(policy)?;
            println!(
                "{}",
                serde_json::to_string_pretty(&arkhe_bugbounty::review::telemetry::compare_shadow(
                    &queue.observations()?,
                    &candidate
                ))?
            );
            return Ok(());
        }
        "seed-origin" if args.len() == 3 => {
            let run = PathBuf::from(&args[2]);
            let report_bytes = std::fs::read(run.join("origin-corrected/report.json"))?;
            let report: ReportDetails = serde_json::from_slice(&report_bytes)?;
            let output_bytes = std::fs::read(run.join("origin-corrected/stdout.txt"))?;
            let output: serde_json::Value = serde_json::from_slice(&output_bytes)?;
            let assessment = &output["assessment"];
            let confidence = assessment["confidence_bps"]
                .as_u64()
                .filter(|n| *n <= 10000)
                .ok_or("invalid historical confidence")? as u16;
            let supports = assessment["supports_proposal"]
                .as_bool()
                .ok_or("invalid historical decision")?;
            let params = TriageParams {
                severity: Severity::High,
                state: State::Triaged,
            };
            if report.report_id != "origin-corrected"
                || output["report_digest"].as_str() != Some(report.digest().to_hex().as_str())
                || output["parameters_digest"].as_str() != Some(params.digest().to_hex().as_str())
            {
                return Err(
                    "historical report/proposal digests do not match retained stdout".into(),
                );
            }
            let request = WorkIntent {
                requested_by: "HISTORICAL-RUN-01-REVIEW".into(),
                intent_type: WorkIntentType::TriageReport,
                target: report.target(),
                parameters_digest: params.digest(),
                context: vec![],
                context_refs: vec![],
                request_identity: RequestIdentity::new(
                    b"review-queue-seed:run-01:origin-corrected",
                ),
                claimed_created_at: 0,
            };
            let signals = ReviewSignals {
                supports_proposal: supports,
                confidence_bps: Some(confidence),
                ambiguous: None,
                text_decision_disagreement: Some(true),
                policy_exception: false,
                irreversible: false,
            };
            let model_version = format!(
                "historical-cli:{}",
                output["provider"]["model_digest"]
                    .as_str()
                    .ok_or("missing historical model pin")?
            );
            let router = ReviewRouter::new(ReviewPolicy::default())?;
            let decision = router.decide(Severity::High, &model_version, &signals);
            queue.enqueue(ReviewItem { completed_execution:None, review_evidence:None, case_id:report.report_id.clone(),requested_by:request.requested_by.clone(),operation_id:request.operation_id(),report_digest:report.digest(),parameters_digest:params.digest(),governance_policy_digest:Digest32::ZERO,severity:Severity::High,model_version,signals,decision,analysis:None,source:format!("Historical run-01; suspected text/decision disagreement flagged by user audit, NOT a human verdict; report_ref={}; stdout_ref={}; no admitted WER or authority",Digest32::blake3(b"AKG:REVIEW:SOURCE:v1\0",&report_bytes).to_hex(),Digest32::blake3(b"AKG:REVIEW:SOURCE:v1\0",&output_bytes).to_hex()) })?;
        }
        _ => return Err("invalid command or arguments".into()),
    }
    println!("{}", serde_json::to_string_pretty(&queue.list()?)?);
    Ok(())
}
