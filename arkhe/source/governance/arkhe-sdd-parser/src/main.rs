//! arkhe-sdd-parser --spec spec.md --tasks tasks.md [--format ears|gwt] [--out DIR]
//!
//! Prints a JSON report. With --out, writes constitution.cbor and tasks.cbor (AKG-CBOR-v1).
//! Exit: 0 parsed and V1 satisfied; 1 parsed but V1 findings; 2 errors.
use arkhe_sdd_parser::{parse_spec, parse_tasks, Severity, SpecFormat};
use serde_json::json;
use std::{fs, path::PathBuf, process::ExitCode};

fn main() -> ExitCode {
    let mut spec = None;
    let mut tasks = None;
    let mut out = None;
    let mut format = None;
    let mut args = std::env::args().skip(1);
    while let Some(a) = args.next() {
        let v = args.next();
        match (a.as_str(), v) {
            ("--spec", Some(v)) => spec = Some(PathBuf::from(v)),
            ("--tasks", Some(v)) => tasks = Some(PathBuf::from(v)),
            ("--out", Some(v)) => out = Some(PathBuf::from(v)),
            ("--format", Some(v)) if v == "ears" => format = Some(SpecFormat::Ears),
            ("--format", Some(v)) if v == "gwt" => format = Some(SpecFormat::GivenWhenThen),
            _ => {
                eprintln!("usage: arkhe-sdd-parser --spec FILE --tasks FILE [--format ears|gwt] [--out DIR]");
                return ExitCode::from(2);
            }
        }
    }
    let (Some(spec), Some(tasks)) = (spec, tasks) else {
        eprintln!("--spec and --tasks are required");
        return ExitCode::from(2);
    };
    let read = |p: &PathBuf| fs::read_to_string(p).map_err(|e| format!("{}: {e}", p.display()));
    let (spec_text, tasks_text) = match (read(&spec), read(&tasks)) {
        (Ok(s), Ok(t)) => (s, t),
        (Err(e), _) | (_, Err(e)) => {
            eprintln!("{e}");
            return ExitCode::from(2);
        }
    };
    let constitution = match parse_spec(&spec_text, format) {
        Ok(c) => c,
        Err(errors) => {
            let report = json!({"ok": false, "diagnostics": errors.iter().map(|d| d.to_json()).collect::<Vec<_>>()});
            println!("{}", serde_json::to_string_pretty(&report).unwrap());
            return ExitCode::from(2);
        }
    };
    let (task_set, diags) = parse_tasks(&tasks_text, &constitution);
    let has_errors = diags.iter().any(|d| d.severity == Severity::Error);
    let report = json!({
        "ok": !has_errors,
        "format": constitution.format.as_str(),
        "constitution_digest": constitution.digest().to_hex(),
        "tasks_digest": task_set.digest().to_hex(),
        "invariants": constitution.invariants.len(),
        "tasks": task_set.tasks.len(),
        "v1_satisfied": task_set.v1_satisfied(),
        "diagnostics": diags.iter().map(|d| d.to_json()).collect::<Vec<_>>(),
    });
    println!("{}", serde_json::to_string_pretty(&report).unwrap());
    if has_errors {
        return ExitCode::from(2);
    }
    if let Some(dir) = out {
        let written = fs::create_dir_all(&dir)
            .and_then(|_| fs::write(dir.join("constitution.cbor"), constitution.canonical_bytes()))
            .and_then(|_| fs::write(dir.join("tasks.cbor"), task_set.canonical_bytes()));
        if let Err(e) = written {
            eprintln!("{}: {e}", dir.display());
            return ExitCode::from(2);
        }
    }
    if task_set.v1_satisfied() {
        ExitCode::SUCCESS
    } else {
        ExitCode::from(1)
    }
}
