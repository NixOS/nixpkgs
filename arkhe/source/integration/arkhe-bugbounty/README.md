# arkhe-bugbounty

Status: IMPLEMENTATION CANDIDATE — NOT FROZEN.

## Review-aware execution

`execute_triage_reviewed` adds the separate ReviewRouter and local prioritized
review queue. Critical/High always require review; unknown signals are conservative.
Use ReviewProtectedPolicy to prohibit the legacy unrouted entry point. AUTO_ACCEPT
never bypasses admitted analysis or governance, and the default review policy
enables no automatic execution. Human approval requires independently admitted
attestation from an approved verification worker; no production human keys or
approvals are provided. See [review routing, activation and limits](../../docs/security/REVIEW-ROUTER-2026-10-18.md).

`TriageExecutor` performs read → scope check → analyze → admit → propose → authorize → execute
→ record. Reports and analyzer output remain untrusted until verified admission.

## Identity and conflict detection

`RequestIdentity` is supplied once by the caller. `operation_id()` now uses
AKG-CBOR-v1 with domain `AKG:OPERATION:v2\0`, binding type, stable target and caller
nonce. **Parameters are excluded** and stored as `parameters_digest` separately.
The exact identity is BLAKE3(`AKG:OPERATION:v2\0` ||
AKG-CBOR-v1({intent_type, target, request_identity})). `parameters_digest` is not
inside this map. Existing regression tests
`operation_id_excludes_parameters_and_timestamp_but_binds_request`,
`same_request_different_parameters_conflicts_without_second_write` and
`pending_request_different_parameters_conflicts` cover this distinction; the
PostgreSQL suite also checks the mismatch across two executors.
The v2 domain prevents confusion with the earlier candidate ID algorithm.
Same identity and parameters replays the result. Same identity and changed
parameters returns `Error::ParameterMismatch` (HTTP adapters should map to 409).
A new intended action needs a new caller nonce.

A HackenProof target is the stable report identifier digest. The report's mutable
content digest is `ContextKind::SourceReport`. Consequently a triage changing
report severity cannot silently create another operation during a retry.
The gate binds admitted analysis input to the source snapshot and output to the
parameters digest; it requires one explicit analysis and source reference.

## Governance and evidence

Severity evidence now has an explicit domain-aware contract: WebMobile may combine
a reviewed table row and a CVSS 3.1 Base vector under trusted policy; the other
domains use a table or justified CVSS fallback. `validate_triage` checks consistency
without inference or external writes. The optional classified Ollama profile binds
classification and policy digests before attestation; legacy analysis is explicitly
unverified for this purpose. The opt-in `VerifiedTriagePolicy` now requires typed classification/policy bindings
in the kernel gate, backed by an Ed25519 quorum and an independently pinned registry.
Unsigned local candidates are not activated automatically. See [classification contract and limits](../../docs/security/TRIAGE-CLASSIFICATION.md).

Governance supplies allowed modules and cognitive operations; missing evidence,
policy, mismatched proposal bindings and unapproved modules fail closed.
`PgKernel<V>` persists canonical WER and envelope atomically in `PgWormGraph`.
`WorkerVerifier` is mandatory. `SignedWorkerVerifier` now implements detached
Ed25519 verification with `verify_strict`, tenant/hash/outcome binding, approved
module/version/operation key bindings and an active/revoked flag. It checks declared
parents through its `EvidenceReader`; execution keys can require admitted input.
Private keys stay with the worker. Deployment must supply approved public trust
roots and a trusted signer, and reload its registry on revocation; no default
accepts self-reported module IDs or hashes. A signed analysis is evidence that a
trusted worker performed that analysis, not proof the underlying report is true.
Database admission is idempotent by record hash and verifies causal parents.
Golden vectors for older empty-context/unspecified-operation objects are preserved.

## Durable journal and operational log

`PgOperations` implements `Journal` and `OperationalLog`, using tenant RLS and
an operations role separate from evidence append/read roles. Migrations are
additive; existing migration source identities are unchanged.

The journal's uniqueness scope is `(tenant, caller, request, type, target)`.
An INSERT/ON CONFLICT transaction compares parameters on collisions. Reservation
is committed before analysis; `DISPATCHED` is committed before the external call.
Only the reservation owner token can dispatch or complete. Concurrent callers see
a cached completed response or a pending outcome; they cannot dispatch twice.

A crash before dispatch leaves PREPARED; timeout/cancellation after dispatch or
failure to admit/store the result leaves DISPATCHED. Both require reconciliation.
**No expired lease or automatic takeover repeats an uncertain external write.**
This is conservative at-most-once dispatch, not exactly-once upstream execution.
`manual_reconciliation_requests` now retains explicit failure/escalation markers.
The read-only `manual_reconciliation list` command reports
`manual_reconciliation_required: true`; `manual_reconciliation metrics` exports
`arkhe_bugbounty_manual_reconciliation_required` per tenant. Unresolved operations
older than five minutes also enter the queue, including cancellation before logging.
Completed operations leave the active queue while their escalation history remains.
These commands neither infer upstream success nor replay an uncertain call.
Operator outcome investigation remains necessary without a reliable upstream query.

Failures and rejections write `bugbounty_operational_log`, never execution-success
evidence. Logs have a 30-day `expires_at`; a deployment maintenance job using
`arkhe_admin` must purge expired entries. Journals are not purged with logs.
`OperationJournal` remains an in-memory reference implementation for local tests.

## Validation

```
cargo test -p arkhe-bugbounty -p arkhe-core -p arkhe-kernel --locked
cargo test -p arkhe-bugbounty --features postgres-integration --locked
```

The second command requires `ARKHE_TEST_DATABASE_URL` for a migrated real
PostgreSQL runtime role with arkhe_append, arkhe_read and arkhe_operations.
Tests cover conflict, retries, concurrency, persistent journal/evidence after
reconnect, two independent executors, tenant isolation, untrusted receipt rejection,
prepared-operation recovery boundaries and partial failure after external write.
The separate-process `persistence_probe` example and
`scripts/bugbounty_restart_probe.py` verify response/evidence survival across an
actual restart of an explicitly labelled local PostgreSQL test container.
The B0 fixture is explicitly synthetic and admitted by a test hash-pinning verifier.
Tests do not attest production provenance verification or a real HackenProof write.

## B0 anchoring

See `ops/besu/README.md`: a four-validator local QBFT network, AnchorRegistry,
export of a persisted WormGraph checkpoint, and offline BLAKE3 MMR verification
through arkhe-verify.wasm. Besu is an anchoring transport, never admission authority.
The dedicated workflow includes actual version enforcement (minimum 26.7.1).
Local evidence does not establish remote CI success or production readiness.

## Remaining external dependencies

The local Ollama analyzer is available; its production signer/custody and governance profile still need configuration. `AuthenticatedMcp` and
`HttpHackenProofClient<W>` provide the HTTP transport and an explicit normalization
boundary. `HackenProofWireCodec` must be supplied from the real authenticated schema;
no default guesses the upstream arguments/response or promises server deduplication.
`HACKENPROOF_API_KEY` is read only when requested by the environment constructor or
catalog command. It is not available in the execution environment for this run.
Before live writes: deploy approved trust roots/signing custody, validate the real
server contract and configure operator reconciliation. No API credentials are
stored here. Public HackenProof documentation confirms MCP triage, but is not a
wire/schema or transactional deduplication specification:
https://hackenproof.com/blog/ai-bug-bounty-triage-mcp-server-hackenproof

## Signed receipts

`SignedWorkerReceipt` is detached from the WER and signs a domain-separated
canonical projection of tenant, key ID, WER hash, completion timestamp and outcome.
`worker_receipts` persists incoming material separately from normative evidence;
only signature/provenance verification permits WER admission. Invalid receipts
never become WormGraph evidence. The test keys are generated by the operating
system RNG and perform real Ed25519 signing/verification, including a signed
parent/child chain against PostgreSQL after reconnect. This does not attest a
production worker, KMS, key distribution, freshness policy or root rotation service.

## MCP contract pinning

The transport deliberately pins MCP protocol `2025-11-25` and rejects another
negotiated version; it does not claim compatibility with newer protocol revisions.
HTTP JSON and SSE are supported with bounded bodies/catalogs, session initialization,
response-ID checks, TLS for non-loopback endpoints, disabled redirects and disabled
HTTP retries. Full tool definitions are pinned, including descriptions, schemas,
annotations and extensions. Pins use sorted-key JSON/serde number encoding with
BLAKE3 domain `AKG:MCP:TOOL:JSON:v1`, separately from WER AKG-CBOR-v1.

```
cargo run -p arkhe-bugbounty --bin mcp_catalog -- ops/local/hackenproof-catalog.json
```

This command needs `HACKENPROOF_API_KEY` injected securely; endpoint override is
`HACKENPROOF_MCP_URL`. It performs initialize/tools-list only and writes an
**untrusted candidate** catalog for review. It does not adopt pins or execute a
triage. `ToolPins::new` requires caller-reviewed expected digests. The client checks
tools-list before each tool call and blocks changed/unapproved definitions.
The independent `HACKENPROOF_TOOL_ALLOWLIST` permits exactly
`get_report_details`, `triage_report`, `get_program_info` and `list_reports`. A reviewed digest cannot grant another
name. Calls outside this allowlist are rejected before tools/list/tools/call;
additional server tools remain discoverable data only. The regression test
`added_server_tool_cannot_expand_integration_allowlist_even_with_a_pin` adds a
server tool while preserving existing pins and verifies it cannot execute.
Pinning detects catalog changes; it cannot make a malicious server truthful or
atomically bind tools/list to a later tools/call. Authenticated upstream testing is
still pending. HTTP tests use a local authenticated MCP server.

Program discovery is now mandatory before analysis. `ProgramScope` binds the exact
report digest, included assets and explicit exclusions. Missing/unknown assets,
exclusions or unsupported discovery fail closed; the executor logs out_of_scope
without invoking the analyzer or admitting execution evidence. Existing wire codecs
must implement `program_call`/`program` and provision a reviewed get_program_info pin.
No upstream schema or scope permission is guessed. This check covers assets, not
factual exploitability or every textual program exclusion.

`taxonomy::topics` exposes the 250 supplied engineering topics. Only direct table
matches have informational HackenProof references; the catalogue does not activate
a classification policy or assign every topic a vulnerability severity.

The user selected keeping the workflow local for this iteration. No remote
checkout, repository, branch or GitHub run was modified.

## Gate scope and legacy PostgreSQL tests

The default workspace gate covers targets that do not require an external database;
it does not establish PostgreSQL conformance. The two original `rls_isolation`
tests now use the explicit `arkhe-sql/postgres-integration` feature/required test
target instead of #[ignore]. With that feature enabled, missing database credentials
are a failure. The local workflow includes arkhe-sql and runs both tests against the
real database alongside the bugbounty persistence suite. No remote run is inferred.

The embedded-asset policy is documented in docs/development/embedded-assets.md and
enforced by the architecture gate. Literal Rust includes are compiler tracked;
proc-macro migration discovery needs explicit directory watches.

## Local Ollama provider

OllamaAnalyzer now implements the provider port using arkhe-ollama, the configured
local endpoint and a pinned installed model. It preserves candidate-only semantics;
model replies cannot authorize a transition or sign their own records. See
integration/arkhe-ollama/README.md for commands, validation and the attestation hook.
Ollama supplies local inference; production custody, policy approval and the
HackenProof wire contract remain deployment prerequisites.

## Signed governance profile

`governance::VerifiedTriagePolicy` verifies a signed profile against a separately
provisioned registry pin, at least two distinct public keys, signer validity/scope
and profile expiry. The executor and classified analyzer bind classification to
the proposal digest; the gate requires the typed WER binding and typed context.
Legacy records remain readable, but cannot satisfy this profile without classification.

The candidates in `governance/profiles/triage-report-v1` and
`governance/trust-registry` contain no actual approvals or keys. See the
[approval runbook](../../governance/profiles/triage-report-v1/README.md). No policy
was made active, no administrator signature was synthesized and no registry
transparency anchor was claimed.
