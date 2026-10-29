use arkhe_bugbounty::{
    classification::{
        cvss31_base_score, ClassificationPolicy, CvssEvidence, CvssRequirement, Domain,
        SeverityBasis, TableRow, TriageAnalysis,
    },
    ReportDetails, Severity, State, TriageParams,
};
fn fixture(
    domain: Domain,
) -> (
    ReportDetails,
    TriageParams,
    ClassificationPolicy,
    TriageAnalysis,
) {
    let report = ReportDetails {
        version: 1,
        report_id: "synthetic".into(),
        severity: Severity::Low,
        title: "synthetic".into(),
        report_body: "Not an exploitability or scope attestation".into(),
        submitted_at: 1,
        affected_assets: vec![],
    };
    let params = TriageParams {
        severity: Severity::High,
        state: State::Triaged,
    };
    let policy = ClassificationPolicy {
        policy_id: "test-only".into(),
        version: 1,
        web_table_cvss: CvssRequirement::Optional,
        web_cvss_only: false,
        rows: vec![TableRow {
            id: "test.high".into(),
            domain,
            severity: Severity::High,
        }],
    };
    let analysis = TriageAnalysis {
        version: 1,
        report_digest: report.digest(),
        parameters_digest: params.digest(),
        domain,
        proposed_severity: Severity::High,
        basis: SeverityBasis::HackenProofTable {
            table_row: "test.high".into(),
            cvss: Some(high_cvss()),
        },
    };
    (report, params, policy, analysis)
}
fn high_cvss() -> CvssEvidence {
    CvssEvidence {
        vector: "CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H".into(),
        score_tenths: 88,
    }
}
#[test]
fn first_base_vectors_and_strict_parser() {
    for (vector, expected) in [
        ("CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H", 98),
        ("CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:C/C:H/I:H/A:H", 100),
        ("CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H", 88),
        ("CVSS:3.1/AV:N/AC:L/PR:L/UI:R/S:C/C:L/I:L/A:N", 54),
        ("CVSS:3.1/AV:P/AC:H/PR:H/UI:R/S:U/C:L/I:N/A:N", 16),
        ("CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:N", 0),
        ("CVSS:3.1/A:H/I:H/C:H/S:U/UI:N/PR:N/AC:L/AV:N", 98),
    ] {
        assert_eq!(cvss31_base_score(vector).unwrap(), expected, "{vector}");
    }
    for vector in [
        "9.8",
        "CVSS:4.0/AV:N",
        "CVSS:3.0/AV:N",
        "CVSS:3.1/AV:N",
        "CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H/AV:N",
        "CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H/E:F",
        "CVSS:3.1/AV:X/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H",
    ] {
        assert!(cvss31_base_score(vector).is_err(), "{vector}");
    }
}
#[test]
fn web_table_and_cvss_policy_is_explicit() {
    let (report, params, mut policy, mut analysis) = fixture(Domain::WebMobile);
    assert!(analysis.validate(&report, params, &policy).is_ok());
    policy.web_table_cvss = CvssRequirement::Forbidden;
    assert!(analysis.validate(&report, params, &policy).is_err());
    if let SeverityBasis::HackenProofTable { cvss, .. } = &mut analysis.basis {
        *cvss = None;
    }
    assert!(analysis.validate(&report, params, &policy).is_ok());
    policy.web_table_cvss = CvssRequirement::Required;
    assert!(analysis.validate(&report, params, &policy).is_err());
    analysis.basis = SeverityBasis::CvssFallback {
        cvss: high_cvss(),
        rationale: "Documented rationale; facts still need independent verification".into(),
    };
    assert!(analysis.validate(&report, params, &policy).is_err());
    policy.web_cvss_only = true;
    assert!(analysis.validate(&report, params, &policy).is_ok());
}
#[test]
fn other_domains_allow_table_or_fallback_but_not_both() {
    for domain in [Domain::SmartContracts, Domain::BlockchainProtocols] {
        let (report, params, policy, mut analysis) = fixture(domain);
        assert!(analysis.validate(&report, params, &policy).is_err());
        if let SeverityBasis::HackenProofTable { cvss, .. } = &mut analysis.basis {
            *cvss = None;
        }
        assert!(analysis.validate(&report, params, &policy).is_ok());
        analysis.basis = SeverityBasis::CvssFallback {
            cvss: high_cvss(),
            rationale: "Not covered by the reviewed table; subject to program review".into(),
        };
        assert!(analysis.validate(&report, params, &policy).is_ok());
    }
}
#[test]
fn mismatched_inputs_scores_tables_and_schema_fail_closed() {
    let (mut report, params, mut policy, mut analysis) = fixture(Domain::WebMobile);
    let original = analysis.digest();
    let policy_digest = policy.digest();
    report.report_body.push('x');
    assert!(analysis.validate(&report, params, &policy).is_err());
    analysis.report_digest = report.digest();
    assert_ne!(analysis.digest(), original);
    let changed = TriageParams {
        severity: Severity::Critical,
        ..params
    };
    assert!(analysis.validate(&report, changed, &policy).is_err());
    let changed = TriageParams {
        state: State::Rejected,
        ..params
    };
    assert!(analysis.validate(&report, changed, &policy).is_err());
    if let SeverityBasis::HackenProofTable { cvss, .. } = &mut analysis.basis {
        cvss.as_mut().unwrap().score_tenths = 98;
    }
    assert!(analysis.validate(&report, params, &policy).is_err());
    policy.rows[0].severity = Severity::Critical;
    assert_ne!(policy.digest(), policy_digest);
    assert!(analysis.validate(&report, params, &policy).is_err());
    policy.rows.push(policy.rows[0].clone());
    assert!(policy.validate().is_err());
    let value = serde_json::json!({ "kind":"HackenProofTable", "table_row":"test.high", "cvss":null, "authorize":true });
    assert!(serde_json::from_value::<SeverityBasis>(value).is_err());
}

#[test]
fn command_checks_real_serialized_evidence_and_exits_nonzero_on_mismatch() {
    let (report, params, policy, analysis) = fixture(Domain::WebMobile);
    let directory =
        std::env::temp_dir().join(format!("arkhe-classification-{}", uuid::Uuid::new_v4()));
    std::fs::create_dir(&directory).unwrap();
    for (name, value) in [
        ("report.json", serde_json::to_value(&report).unwrap()),
        ("analysis.json", serde_json::to_value(&analysis).unwrap()),
        ("policy.json", serde_json::to_value(&policy).unwrap()),
    ] {
        std::fs::write(directory.join(name), serde_json::to_vec(&value).unwrap()).unwrap();
    }
    let run = |severity: &str| {
        std::process::Command::new(env!("CARGO_BIN_EXE_validate_triage"))
            .arg(directory.join("report.json"))
            .arg(directory.join("analysis.json"))
            .arg(directory.join("policy.json"))
            .arg(severity)
            .arg("Triaged")
            .output()
            .unwrap()
    };
    let good = run("High");
    assert!(
        good.status.success(),
        "{}",
        String::from_utf8_lossy(&good.stderr)
    );
    let output: serde_json::Value = serde_json::from_slice(&good.stdout).unwrap();
    assert_eq!(output["status"], "CONSISTENT_UNTRUSTED_PROPOSAL");
    assert_eq!(output["parameters_digest"], params.digest().to_hex());
    assert_eq!(output["classification_digest"], analysis.digest().to_hex());
    assert_eq!(output["cvss"]["score_tenths"], 88);
    assert_eq!(output["cvss"]["score_decimal"], "8.8");
    assert!(!run("Critical").status.success());
}

#[test]
fn decimal_presentation_is_derived_validated_and_not_an_input_field() {
    for (vector, score, decimal) in [
        ("CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:C/C:H/I:H/A:H", 100, "10.0"),
        ("CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H", 88, "8.8"),
        ("CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:N", 0, "0.0"),
    ] {
        let cvss = CvssEvidence {
            vector: vector.into(),
            score_tenths: score,
        };
        let original = serde_json::to_value(&cvss).unwrap();
        assert!(original.get("score_decimal").is_none());
        let presentation = cvss.presentation().unwrap();
        assert_eq!(presentation.score_decimal, decimal);
        assert_eq!(presentation.score_tenths, score);
        let mut forged = original;
        forged["score_decimal"] = serde_json::json!("9.9");
        assert!(serde_json::from_value::<CvssEvidence>(forged).is_err());
        let invalid = CvssEvidence {
            score_tenths: score.saturating_add(1),
            ..cvss
        };
        assert!(invalid.presentation().is_err());
    }
    let (_, _, _, mut analysis) = fixture(Domain::WebMobile);
    let hash = analysis.digest();
    assert_eq!(
        analysis.cvss_presentation().unwrap().unwrap().score_decimal,
        "8.8"
    );
    assert_eq!(
        analysis.digest(),
        hash,
        "presentation must not change evidence identity"
    );
    if let SeverityBasis::HackenProofTable { cvss, .. } = &mut analysis.basis {
        *cvss = None;
    }
    assert!(analysis.cvss_presentation().unwrap().is_none());
}
