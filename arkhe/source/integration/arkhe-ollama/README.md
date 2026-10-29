# Arkhe × Ollama (local provider)

The local provider uses the installed Ollama HTTP API and the existing
north-mini-code-1.0:latest model. config/ollama.json pins the installed digest;
a changed/missing model fails closed. No model is downloaded automatically.

## Use from the repository root

```
python scripts/ollama.py status
python scripts/ollama.py chat "Explique a arquitetura Arkhe em português."
python scripts/ollama.py triage report.json High Triaged
```

Equivalent package commands: pnpm ollama:status, pnpm ollama:chat -- "prompt",
and pnpm ollama:triage -- report.json High Triaged.
The launcher uses C:/Users/Lemes/AppData/Local/Programs/Ollama/ollama.exe on this
Windows account, starts serve hidden only when necessary, and reuses an existing
server. Generated server logs stay in ignored ops/local. It leaves the Ollama
service running for subsequent requests.

Override ARKHE_OLLAMA_EXE for another binary and ARKHE_OLLAMA_CONFIG for another
configuration when invoking Rust directly; the Python launcher takes --config.
Local origin, model/digest, timeout, context and output bounds are configured in
config/ollama.json. The default origin is http://127.0.0.1:11434. This integration
accepts loopback only, disables redirects/proxies/retries and does not enable tools.
The model is 18 GB: first loading/generation on this machine can take minutes.

## Arkhe analysis boundary

arkhe-bugbounty::ollama::OllamaAnalyzer implements LlmAnalyzer. It requests a JSON
schema, parses and bounds the result independently, and checks whether the model
supports the caller's proposal. A disagreeing or malformed result produces an error,
not a successful worker record. Report text is serialized in a separate untrusted
user message with a fresh boundary identifier. That identifier is formatting;
it is not a prompt-injection guarantee.

An accepted candidate WER binds the report digest, parameters digest, model identity,
response/assessment digest and confidence. MODULE_ID is ollama-triage-v1.
New records set module_version to `<adapter-version>+model.<model-digest>`.
The independent TrustedWorkerKey registry must approve that exact version; a
different model needs a reviewed binding. Old evidence is not rewritten. The
output_digest remains the proposal digest required by ContainmentGate; the
analysis artifact digest and model details are also covered by the WER preimage.
Governance must explicitly approve that module. No policy allowlist is expanded by
installing the provider, and model confidence never grants authority.
An optional AnalysisAttestor hook can call a trusted signing service and stage a
detached receipt. With no attestor, the WER remains unsigned; SignedWorkerVerifier
will reject admission without a valid authorized receipt. The CLI triage command
prints UNTRUSTED_PROPOSAL data only. It never writes to HackenProof or WormGraph.

The existing TriageExecutor can receive this analyzer in place of a stub. Production
usage still requires configured signer/custody, verified admission and governance.
The HackenProof credentials/codec and external outcome reconciliation remain separate.

## Verify

```
cargo test -p arkhe-ollama -p arkhe-bugbounty --test client --test ollama --locked
```

The default tests use an HTTP fixture for timeouts, changed digests, truncated
responses, unexpected tools, malformed assessments, disagreement and WER bindings.
Real inference is an explicit feature gate that requires an available model:

```
# Set ARKHE_OLLAMA_CONFIG to an absolute path to config/ollama.json.
cargo test -p arkhe-ollama --features ollama-integration --test ollama_live --locked -- --nocapture
```

The bugbounty boundary probe uses one actual inference, then reuses its candidate
record for four deterministic infrastructure checks: missing admitted evidence,
execution failure/logging, completed retry and parameter conflict. Policy,
scope, admission and upstream writes are explicitly synthetic. It neither
invokes the real HackenProof API nor evaluates a holdout or semantic accuracy.

```powershell
$env:ARKHE_OLLAMA_CONFIG=(Resolve-Path config/ollama.json).Path
cargo test -p arkhe-bugbounty --features ollama-integration --test triage actual_ollama_analysis_obeys_admission_failure_retry_and_conflict_boundaries --locked -- --nocapture
```

## Limits of the local provider

Temperature zero and a pinned model do not guarantee repeatable output across
hardware, runtimes, concurrency or fresh prompt nonces. JSON Schema constrains
shape, not factual correctness. Nonce boundaries do not prevent all injection.
The current analyzer assesses the caller's severity/state proposal; it does not
generate a new severity, activate a classification policy or authorize a write.

Loopback is not a proof of no egress: the local daemon can be compromised or
configured to forward requests. This client rejects known cloud model suffixes
and remote model metadata, as well as duplicate matching catalog entries. It
checks the tag digest before and after inference to detect observable drift;
the API checks are not atomic weight attestation. Enforce cloud disablement and
egress restrictions at the service/deployment boundary for sensitive reports.
No telemetry/network isolation or confidential-computing claim is made here.

No tools are passed to inference, and returned tool calls fail closed. Program
scope is fetched by TriageExecutor before analysis using independently reviewed
MCP pins. search_comments/get_attachments are not silently added to the allowlist.
No auxiliary model fallback, download or model switch occurs. Such a route needs
separate evaluation and approved per-model worker bindings before activation.

API references: https://docs.ollama.com/api/chat and
https://docs.ollama.com/capabilities/structured-outputs . A valid JSON response is
untrusted model output, not proof that a report is correct or an action is authorized.
