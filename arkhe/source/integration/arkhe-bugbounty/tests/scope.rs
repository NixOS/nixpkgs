use arkhe_bugbounty::{scope::ProgramScope, ReportDetails, Severity};
use arkhe_core::Digest32;

#[test]
fn scope_requires_all_assets_binds_snapshot_and_exclusions_win() {
    let mut report = ReportDetails {
        version: 1,
        report_id: "r".into(),
        severity: Severity::Low,
        title: "fixture".into(),
        report_body: "synthetic".into(),
        submitted_at: 1,
        affected_assets: vec![Digest32([1; 32])],
    };
    let mut scope = ProgramScope {
        version: 1,
        program_id: "p".into(),
        report_digest: report.digest(),
        included_assets: report.affected_assets.clone(),
        excluded_assets: vec![],
    };
    assert!(scope.check(&report).is_ok());
    scope.excluded_assets = report.affected_assets.clone();
    assert!(scope.check(&report).is_err());
    scope.excluded_assets.clear();
    report.report_body.push('!');
    assert!(scope.check(&report).is_err());
    report.affected_assets.clear();
    scope.report_digest = report.digest();
    assert!(scope.check(&report).is_err());
}
