//! arkhe-sdd-parser: `spec.md` + `tasks.md` -> `SpecConstitution` + `TaskIntent`s,
//! encoded as AKG-CBOR-v1 (`arkhe_core::canonical`).
//!
//! Accepted spec formats (not mixed in one file):
//! - EARS (Kiro, cc-sdd): `[WHILE|WHEN|WHERE|IF <cond>,]* [THEN] THE <system> SHALL [NOT] <response>`.
//! - Spec Kit: `**Given** .., **When** .., **Then** ..` scenarios under `User Story N`,
//!   and `FR-NNN: <subject> MUST [NOT]|MAY <response>`.
//!
//! Fail-closed: a block that looks like a criterion but does not parse is an error,
//! never a silently dropped invariant. The parser checks V1 (task -> criterion);
//! it does not decide Allow/Reject. Priority is not derivable from a spec and is not emitted.
use arkhe_core::work::{ContextEntry, ContextKind, RequestIdentity, WorkIntent, WorkIntentType};
use arkhe_core::{canonical::encode_value, Digest32};
use arkhe_governance::constitution_graph::Modality;
use regex::Regex;
use serde_json::{json, Value};
use std::collections::{BTreeMap, BTreeSet};

pub const DOMAIN_INVARIANT: &[u8] = b"AKG:SDD:INVARIANT:v1\0";
pub const DOMAIN_CONSTITUTION: &[u8] = b"AKG:SDD:CONSTITUTION:v1\0";
pub const DOMAIN_TASK: &[u8] = b"AKG:SDD:TASK:v1\0";
pub const DOMAIN_TASKS: &[u8] = b"AKG:SDD:TASKS:v1\0";
pub const DOMAIN_TASK_TARGET: &[u8] = b"AKG:SDD:TASK-TARGET:v1\0";

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum SpecFormat {
    Ears,
    GivenWhenThen,
}

impl SpecFormat {
    pub fn as_str(self) -> &'static str {
        match self {
            SpecFormat::Ears => "ears",
            SpecFormat::GivenWhenThen => "gwt",
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum CriterionKind {
    Ubiquitous,
    EventDriven,
    StateDriven,
    OptionalFeature,
    Unwanted,
    Complex,
    Scenario,
    FunctionalRequirement,
}

impl CriterionKind {
    fn as_str(self) -> &'static str {
        match self {
            CriterionKind::Ubiquitous => "ubiquitous",
            CriterionKind::EventDriven => "event_driven",
            CriterionKind::StateDriven => "state_driven",
            CriterionKind::OptionalFeature => "optional_feature",
            CriterionKind::Unwanted => "unwanted",
            CriterionKind::Complex => "complex",
            CriterionKind::Scenario => "scenario",
            CriterionKind::FunctionalRequirement => "functional_requirement",
        }
    }
}

fn modality_str(m: Modality) -> &'static str {
    match m {
        Modality::Obligatory => "obligatory",
        Modality::Optional => "optional",
        Modality::Impermissible => "impermissible",
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Condition {
    /// WHEN | WHILE | WHERE | IF | GIVEN
    pub keyword: String,
    pub text: String,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Invariant {
    pub id: String,
    pub kind: CriterionKind,
    pub modality: Modality,
    /// Empty for Given/When/Then scenarios, which name no system.
    pub subject: String,
    pub response: String,
    pub conditions: Vec<Condition>,
    /// 1-based line in spec.md; diagnostic only, not part of the digest.
    pub line: usize,
}

impl Invariant {
    /// Number of preconditions: more conditions, narrower applicability.
    pub fn specificity(&self) -> usize {
        self.conditions.len()
    }

    fn projection(&self) -> Value {
        json!({
            "id": self.id,
            "kind": self.kind.as_str(),
            "modality": modality_str(self.modality),
            "subject": self.subject,
            "response": self.response,
            "conditions": self.conditions.iter()
                .map(|c| json!({"keyword": c.keyword, "text": c.text}))
                .collect::<Vec<_>>(),
            "specificity": self.specificity(),
        })
    }

    pub fn digest(&self) -> Digest32 {
        Digest32::blake3(DOMAIN_INVARIANT, &encode_value(&self.projection()))
    }
}

#[derive(Debug, Clone)]
pub struct SpecConstitution {
    pub format: SpecFormat,
    /// Sorted by id.
    pub invariants: Vec<Invariant>,
}

impl SpecConstitution {
    pub fn canonical_bytes(&self) -> Vec<u8> {
        let invariants: Vec<Value> = self
            .invariants
            .iter()
            .map(|i| {
                let mut v = i.projection();
                v["hash"] = json!(i.digest().0.to_vec());
                v
            })
            .collect();
        encode_value(&json!({"format": self.format.as_str(), "invariants": invariants}))
    }

    pub fn digest(&self) -> Digest32 {
        Digest32::blake3(DOMAIN_CONSTITUTION, &self.canonical_bytes())
    }

    /// Coherence: duplicate ids and direct deontic conflicts (same subject,
    /// response and conditions under contradicting modalities).
    pub fn check(&self) -> Vec<Diagnostic> {
        let mut out = Vec::new();
        if self.invariants.is_empty() {
            out.push(Diagnostic::error(0, "empty_constitution", "spec contains no criteria"));
        }
        let mut seen = BTreeMap::new();
        for inv in &self.invariants {
            if let Some(prev) = seen.insert(inv.id.clone(), inv.line) {
                out.push(Diagnostic::error(
                    inv.line,
                    "duplicate_id",
                    format!("criterion id {} already defined at line {prev}", inv.id),
                ));
            }
        }
        let key = |i: &Invariant| {
            let conds: Vec<String> = i
                .conditions
                .iter()
                .map(|c| format!("{}:{}", c.keyword, c.text.to_lowercase()))
                .collect();
            (i.subject.to_lowercase(), i.response.to_lowercase(), conds)
        };
        for (n, a) in self.invariants.iter().enumerate() {
            for b in &self.invariants[n + 1..] {
                let conflicting = matches!(
                    (a.modality, b.modality),
                    (Modality::Impermissible, Modality::Obligatory | Modality::Optional)
                        | (Modality::Obligatory | Modality::Optional, Modality::Impermissible)
                );
                if conflicting && key(a) == key(b) {
                    out.push(Diagnostic::error(
                        b.line,
                        "deontic_conflict",
                        format!("{} contradicts {}", b.id, a.id),
                    ));
                }
            }
        }
        out
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Severity {
    Error,
    /// Not a parse failure; the gate decides (e.g. V1 unmapped task).
    Finding,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Diagnostic {
    pub severity: Severity,
    pub line: usize,
    pub code: &'static str,
    pub message: String,
}

impl Diagnostic {
    fn error(line: usize, code: &'static str, message: impl Into<String>) -> Self {
        Self { severity: Severity::Error, line, code, message: message.into() }
    }
    fn finding(line: usize, code: &'static str, message: impl Into<String>) -> Self {
        Self { severity: Severity::Finding, line, code, message: message.into() }
    }
    pub fn to_json(&self) -> Value {
        json!({
            "severity": match self.severity { Severity::Error => "error", Severity::Finding => "finding" },
            "line": self.line, "code": self.code, "message": self.message,
        })
    }
}

/// Collapse whitespace and drop markdown bold markers.
fn normalize(s: &str) -> String {
    s.replace("**", "").split_whitespace().collect::<Vec<_>>().join(" ")
}

struct Block {
    line: usize,
    text: String,
    heading: Option<String>,
}

/// Splits markdown into headings, list items (with continuation lines) and paragraphs.
fn blocks(text: &str) -> Vec<Block> {
    let item = Regex::new(r"^\s*(?:\d+\.|[-*])\s+").unwrap();
    let heading = Regex::new(r"^#{1,6}\s+(.*)$").unwrap();
    let mut out: Vec<Block> = Vec::new();
    let mut open = false;
    for (n, raw) in text.replace("\r\n", "\n").lines().enumerate() {
        let line = n + 1;
        if raw.trim().is_empty() {
            open = false;
        } else if let Some(h) = heading.captures(raw) {
            out.push(Block { line, text: String::new(), heading: Some(normalize(&h[1])) });
            open = false;
        } else if item.is_match(raw) || !open {
            out.push(Block { line, text: item.replace(raw, "").trim().to_string(), heading: None });
            open = true;
        } else {
            let last = out.last_mut().expect("open block");
            last.text.push('\n');
            last.text.push_str(raw.trim());
        }
    }
    out
}

pub fn detect_format(spec: &str) -> Result<SpecFormat, Diagnostic> {
    let ears = Regex::new(r"\bSHALL\b").unwrap().is_match(spec);
    let gwt = Regex::new(r"(?im)(\*\*given\*\*|^\s*(?:\d+\.|[-*])?\s*given\s.*\bthen\b|\bFR-\d+\b)")
        .unwrap()
        .is_match(spec);
    match (ears, gwt) {
        (true, false) => Ok(SpecFormat::Ears),
        (false, true) => Ok(SpecFormat::GivenWhenThen),
        (true, true) => Err(Diagnostic::error(0, "ambiguous_format", "spec mixes EARS and Given/When/Then; pass the format explicitly")),
        (false, false) => Err(Diagnostic::error(0, "unknown_format", "no EARS (SHALL) or Given/When/Then criteria found")),
    }
}

/// Parses spec.md. `Err` carries every error found; findings never appear here.
pub fn parse_spec(spec: &str, format: Option<SpecFormat>) -> Result<SpecConstitution, Vec<Diagnostic>> {
    let format = match format {
        Some(f) => f,
        None => detect_format(spec).map_err(|d| vec![d])?,
    };
    let mut errors = Vec::new();
    let clarification = Regex::new(r"\[NEEDS CLARIFICATION").unwrap();
    for (n, l) in spec.lines().enumerate() {
        if clarification.is_match(l) {
            errors.push(Diagnostic::error(n + 1, "needs_clarification", "unresolved [NEEDS CLARIFICATION] marker"));
        }
    }
    let mut invariants = match format {
        SpecFormat::Ears => parse_ears(spec, &mut errors),
        SpecFormat::GivenWhenThen => parse_gwt(spec, &mut errors),
    };
    invariants.sort_by(|a, b| a.id.cmp(&b.id));
    let constitution = SpecConstitution { format, invariants };
    errors.extend(constitution.check());
    if errors.is_empty() {
        Ok(constitution)
    } else {
        Err(errors)
    }
}

fn parse_ears(spec: &str, errors: &mut Vec<Diagnostic>) -> Vec<Invariant> {
    let shall = Regex::new(r"\bSHALL\b").unwrap();
    let req_num = Regex::new(r"(?i)^requirement\s+(\d+)\b").unwrap();
    let req_title = Regex::new(r"(?i)^requirement\s*:\s*(.+)$").unwrap();
    let mut key = "R".to_string();
    let mut counter = 0usize;
    let mut out = Vec::new();
    for b in blocks(spec) {
        if let Some(h) = &b.heading {
            if let Some(c) = req_num.captures(h) {
                key = c[1].to_string();
                counter = 0;
            } else if let Some(c) = req_title.captures(h) {
                key = slug(&c[1]);
                counter = 0;
            }
            continue;
        }
        let text = b.text.replace("**", "");
        match shall.find_iter(&text).count() {
            0 => continue,
            1 => {}
            _ => {
                errors.push(Diagnostic::error(b.line, "multiple_shall", "one EARS criterion per block"));
                continue;
            }
        }
        counter += 1;
        match ears_criterion(&text) {
            Ok((kind, modality, subject, response, conditions)) => out.push(Invariant {
                id: format!("{key}.{counter}"),
                kind,
                modality,
                subject,
                response,
                conditions,
                line: b.line,
            }),
            Err(m) => errors.push(Diagnostic::error(b.line, "malformed_ears", m)),
        }
    }
    out
}

type Parsed = (CriterionKind, Modality, String, String, Vec<Condition>);

fn ears_criterion(text: &str) -> Result<Parsed, String> {
    let at = Regex::new(r"\bSHALL\b").unwrap().find(text).expect("one SHALL");
    let (left, right) = (&text[..at.start()], text[at.end()..].trim());
    let (modality, response) = match right.strip_prefix("NOT ") {
        Some(r) => (Modality::Impermissible, normalize(r)),
        None => (Modality::Obligatory, normalize(right)),
    };
    if response.is_empty() {
        return Err("empty response after SHALL".into());
    }
    let kw = Regex::new(r"\b(WHEN|WHILE|WHERE|IF|THEN)\b").unwrap();
    let marks: Vec<_> = kw.find_iter(left).collect();
    let mut clauses: Vec<(String, String)> = Vec::new();
    if let Some(first) = marks.first() {
        if !left[..first.start()].trim().is_empty() {
            return Err("text before the first EARS keyword".into());
        }
    }
    for (n, m) in marks.iter().enumerate() {
        let end = marks.get(n + 1).map_or(left.len(), |next| next.start());
        clauses.push((m.as_str().to_string(), left[m.end()..end].to_string()));
    }
    if clauses.iter().filter(|c| c.0 == "THEN").count() > 1
        || clauses.iter().position(|c| c.0 == "THEN").is_some_and(|p| p + 1 != clauses.len())
    {
        return Err("THEN must appear at most once, as the last clause".into());
    }
    let subject_raw;
    let mut conditions = Vec::new();
    match clauses.last() {
        None if !Regex::new(r"(?i)^\s*the\s").unwrap().is_match(left) => {
            return Err("ubiquitous criterion must read 'THE <system> SHALL'".into())
        }
        None => subject_raw = left.to_string(),
        Some((k, t)) if k == "THEN" => {
            subject_raw = t.clone();
            clauses.pop();
        }
        Some((_, t)) => {
            let split = Regex::new(r"(?is)^(.*)(?:,|\n)\s*(the\s.*)$").unwrap();
            let c = split
                .captures(t)
                .ok_or("cannot locate the system subject (expected ', THE <system> SHALL')")?;
            subject_raw = c[2].to_string();
            let cond = c[1].to_string();
            let last = clauses.len() - 1;
            clauses[last].1 = cond;
        }
    }
    for (k, t) in &clauses {
        let text = normalize(t).trim_end_matches(',').trim().to_string();
        if text.is_empty() {
            return Err(format!("empty {k} condition"));
        }
        conditions.push(Condition { keyword: k.clone(), text });
    }
    let subject = normalize(&subject_raw);
    let subject = Regex::new(r"(?i)^the\s+").unwrap().replace(&subject, "").to_string();
    if subject.is_empty() {
        return Err("empty system subject".into());
    }
    let kinds: BTreeSet<&str> = conditions.iter().map(|c| c.keyword.as_str()).collect();
    let kind = match kinds.iter().copied().collect::<Vec<_>>().as_slice() {
        [] => CriterionKind::Ubiquitous,
        ["WHEN"] => CriterionKind::EventDriven,
        ["WHILE"] => CriterionKind::StateDriven,
        ["WHERE"] => CriterionKind::OptionalFeature,
        ["IF"] => CriterionKind::Unwanted,
        _ => CriterionKind::Complex,
    };
    Ok((kind, modality, subject, response, conditions))
}

fn parse_gwt(spec: &str, errors: &mut Vec<Diagnostic>) -> Vec<Invariant> {
    let story = Regex::new(r"(?i)^user story\s+(\d+)\b").unwrap();
    let fr = Regex::new(r"^(FR-\d+)\s*:\s*(.+)$").unwrap();
    let must = Regex::new(r"\b(MUST NOT|MUST|MAY)\b").unwrap();
    let starts_given = Regex::new(r"(?i)^given\s").unwrap();
    let scenario =
        Regex::new(r"(?is)^given\s+(.+?),?\s+when\s+(.+?),?\s+then\s+(.+)$").unwrap();
    let mut current: Option<String> = None;
    let mut counter = 0usize;
    let mut out = Vec::new();
    for b in blocks(spec) {
        if let Some(h) = &b.heading {
            if let Some(c) = story.captures(h) {
                current = Some(c[1].to_string());
                counter = 0;
            }
            continue;
        }
        let text = normalize(&b.text);
        if let Some(c) = fr.captures(&text) {
            let body = &c[2];
            let Some(m) = must.find(body) else {
                errors.push(Diagnostic::error(b.line, "malformed_fr", "FR without MUST, MUST NOT or MAY"));
                continue;
            };
            let modality = match m.as_str() {
                "MUST NOT" => Modality::Impermissible,
                "MAY" => Modality::Optional,
                _ => Modality::Obligatory,
            };
            let response = body[m.end()..].trim().to_string();
            if response.is_empty() {
                errors.push(Diagnostic::error(b.line, "malformed_fr", "empty FR response"));
                continue;
            }
            out.push(Invariant {
                id: c[1].to_string(),
                kind: CriterionKind::FunctionalRequirement,
                modality,
                subject: body[..m.start()].trim().to_string(),
                response,
                conditions: vec![],
                line: b.line,
            });
        } else if starts_given.is_match(&text) {
            let Some(c) = scenario.captures(&text) else {
                errors.push(Diagnostic::error(b.line, "malformed_scenario", "expected Given .., When .., Then .."));
                continue;
            };
            let Some(us) = &current else {
                errors.push(Diagnostic::error(b.line, "scenario_without_story", "scenario outside a 'User Story N' section"));
                continue;
            };
            counter += 1;
            out.push(Invariant {
                id: format!("US{us}.AS{counter}"),
                kind: CriterionKind::Scenario,
                modality: Modality::Obligatory,
                subject: String::new(),
                response: c[3].trim().to_string(),
                conditions: vec![
                    Condition { keyword: "GIVEN".into(), text: c[1].trim().to_string() },
                    Condition { keyword: "WHEN".into(), text: c[2].trim().to_string() },
                ],
                line: b.line,
            });
        }
    }
    out
}

fn slug(s: &str) -> String {
    let mut out = String::new();
    for ch in s.trim().to_lowercase().chars() {
        if ch.is_alphanumeric() {
            out.push(ch);
        } else if !out.ends_with('-') {
            out.push('-');
        }
    }
    out.trim_matches('-').to_string()
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct TaskIntent {
    pub task_id: String,
    pub description: String,
    /// Resolved criterion ids, sorted. Empty means V1 is not satisfied for this task.
    pub refs: Vec<String>,
    /// True when other tasks are numbered under this one (Kiro `1` -> `1.1`).
    pub is_group: bool,
    pub line: usize,
}

impl TaskIntent {
    fn projection(&self, constitution: Digest32) -> Value {
        json!({
            "task_id": self.task_id,
            "description": self.description,
            "refs": self.refs,
            "policy_digest": constitution.0.to_vec(),
        })
    }

    /// Binds description, resolved criteria and constitution; maps to
    /// `WorkIntent::parameters_digest`.
    pub fn parameters_digest(&self, constitution: Digest32) -> Digest32 {
        Digest32::blake3(DOMAIN_TASK, &encode_value(&self.projection(constitution)))
    }

    /// Task identity scoped to its constitution, so `T001` of two specs never collide.
    pub fn target(&self, constitution: Digest32) -> Digest32 {
        let mut payload = constitution.0.to_vec();
        payload.extend_from_slice(self.task_id.as_bytes());
        Digest32::blake3(DOMAIN_TASK_TARGET, &payload)
    }

    /// Caller-supplied fields are not derivable from the spec: who requests the work,
    /// the per-request idempotency key (reused on retries) and the claimed time.
    /// The constitution digest travels as a `Policy` context entry.
    pub fn to_work_intent(
        &self,
        constitution: Digest32,
        requested_by: &str,
        request_key: &[u8],
        claimed_created_at: i64,
    ) -> WorkIntent {
        WorkIntent {
            requested_by: requested_by.to_string(),
            intent_type: WorkIntentType::Implement,
            target: self.target(constitution),
            parameters_digest: self.parameters_digest(constitution),
            context: vec![ContextEntry { kind: ContextKind::Policy, hash: constitution }],
            context_refs: vec![],
            request_identity: RequestIdentity::new(request_key),
            claimed_created_at,
        }
    }
}

#[derive(Debug, Clone)]
pub struct TaskSet {
    pub constitution: Digest32,
    /// Sorted by task_id.
    pub tasks: Vec<TaskIntent>,
}

impl TaskSet {
    pub fn canonical_bytes(&self) -> Vec<u8> {
        let tasks: Vec<Value> = self.tasks.iter().map(|t| t.projection(self.constitution)).collect();
        encode_value(&json!({"policy_digest": self.constitution.0.to_vec(), "tasks": tasks}))
    }

    pub fn digest(&self) -> Digest32 {
        Digest32::blake3(DOMAIN_TASKS, &self.canonical_bytes())
    }

    /// V1: every non-group task references at least one criterion.
    pub fn v1_satisfied(&self) -> bool {
        self.tasks.iter().all(|t| t.is_group || !t.refs.is_empty())
    }
}

/// Parses tasks.md (Spec Kit `T001 [P] [US1] ..` or Kiro `1.1 .. _Requirements: 1.2_`)
/// and resolves references against the constitution. Unknown references are errors;
/// unmapped tasks and uncovered criteria are findings.
pub fn parse_tasks(tasks: &str, c: &SpecConstitution) -> (TaskSet, Vec<Diagnostic>) {
    let checkbox = Regex::new(r"^\s*[-*]\s+\[[ xX]\]\s+(.+)$").unwrap();
    let spec_kit_id = Regex::new(r"^(T\d+)\b\s*(.*)$").unwrap();
    let kiro_id = Regex::new(r"^(\d+(?:\.\d+)*)\.?\s+(.*)$").unwrap();
    let story_tag = Regex::new(r"\[US(\d+)\]").unwrap();
    let fr_ref = Regex::new(r"\bFR-\d+\b").unwrap();
    let kiro_refs = Regex::new(r"_Requirements:\s*([^_]+)_").unwrap();
    let known: BTreeSet<&str> = c.invariants.iter().map(|i| i.id.as_str()).collect();
    let mut diags = Vec::new();
    // (line, id, description, details)
    let mut raw: Vec<(usize, String, String, String)> = Vec::new();
    for (n, l) in tasks.replace("\r\n", "\n").lines().enumerate() {
        if let Some(cap) = checkbox.captures(l) {
            let body = cap[1].trim();
            let parsed = spec_kit_id.captures(body).or_else(|| kiro_id.captures(body));
            match parsed {
                Some(p) => raw.push((n + 1, p[1].to_string(), normalize(&p[2]), String::new())),
                None => diags.push(Diagnostic::error(n + 1, "task_without_id", "checkbox task has no T### or numeric id")),
            }
        } else if !l.trim().is_empty() && !l.trim_start().starts_with('#') && l.starts_with(char::is_whitespace) {
            if let Some(last) = raw.last_mut() {
                last.3.push_str(l.trim());
                last.3.push('\n');
            }
        }
    }
    let mut seen = BTreeSet::new();
    let ids: Vec<String> = raw.iter().map(|r| r.1.clone()).collect();
    let mut out = Vec::new();
    for (line, id, description, details) in raw {
        if !seen.insert(id.clone()) {
            diags.push(Diagnostic::error(line, "duplicate_task", format!("task {id} declared twice")));
            continue;
        }
        let mut refs = BTreeSet::new();
        let mut explicit: Vec<String> = fr_ref
            .find_iter(&format!("{description}\n{details}"))
            .map(|m| m.as_str().to_string())
            .collect();
        for cap in kiro_refs.captures_iter(&details) {
            explicit.extend(cap[1].split(',').map(|s| s.trim().to_string()).filter(|s| !s.is_empty()));
        }
        for r in explicit {
            if known.contains(r.as_str()) {
                refs.insert(r);
            } else {
                diags.push(Diagnostic::error(line, "unknown_reference", format!("task {id} references unknown criterion {r}")));
            }
        }
        for cap in story_tag.captures_iter(&description) {
            let prefix = format!("US{}.", &cap[1]);
            let story: Vec<&str> = known.iter().copied().filter(|k| k.starts_with(&prefix)).collect();
            if story.is_empty() {
                diags.push(Diagnostic::error(line, "unknown_reference", format!("task {id} references US{} with no scenarios", &cap[1])));
            }
            refs.extend(story.into_iter().map(String::from));
        }
        let group_prefix = format!("{id}.");
        let is_group = ids.iter().any(|other| other.starts_with(&group_prefix));
        if refs.is_empty() && !is_group {
            diags.push(Diagnostic::finding(line, "v1_unmapped_task", format!("task {id} maps to no spec criterion")));
        }
        out.push(TaskIntent { task_id: id, description, refs: refs.into_iter().collect(), is_group, line });
    }
    let covered: BTreeSet<&str> = out.iter().flat_map(|t| t.refs.iter().map(String::as_str)).collect();
    for inv in &c.invariants {
        if !covered.contains(inv.id.as_str()) {
            diags.push(Diagnostic::finding(inv.line, "uncovered_criterion", format!("criterion {} is covered by no task", inv.id)));
        }
    }
    out.sort_by(|a, b| a.task_id.cmp(&b.task_id));
    (TaskSet { constitution: c.digest(), tasks: out }, diags)
}
