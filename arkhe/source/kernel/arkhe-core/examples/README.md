# Core golden vectors v1

From the workspace root, run:

```powershell
cargo run --offline -p arkhe-core --example golden-vectors-v1 | Set-Content -Encoding utf8 golden-vectors-v1.json
cargo test --offline -p arkhe-core --test golden_vectors
python scripts/generate_core_conformance_vectors.py --check
cargo test --offline -p arkhe-core --example golden-vectors-v1
```

The exporter computes canonical CBOR and domain-separated object digests with
`arkhe-core`. Before emitting any JSON, it compares every result against the
independent Python fixtures in `tests/golden_vectors.json` and
`tests/classification_vectors.json`, plus `tests/core_conformance_vectors.json`.
The last file is reproducible with `scripts/generate_core_conformance_vectors.py`.
Unknown components, duplicate IDs, and
reference mismatches abort the export. The independent fixtures are not updated.
Output is deterministic and contains no generation timestamp.

Scope: WorkIntent, WorkerExecutionRecord (including optional classification and
10,000 evidence references), and the proposed Unity MatchSummary v1. Every row
has `expected: ACCEPT|REJECT` and `status: READY` after successful validation.
Rejections have a descriptive `rejection_reason` and no `expected_output`.
The exporter checks rejection via typed deserialization and, for MatchSummary,
explicit version/survival bounds validation before encoding. It does not use a
panic from the generic CBOR encoder as a rejection result.

WorkIntent and WER now reject unknown top-level JSON fields. WER JSON parsing
rejects confidence outside 0..10000 (null/missing remain accepted). Rust code
constructing WER directly must still enforce the semantic range itself; this
change validates deserialization, not every possible in-memory construction.

MatchSummary mirrors the fields in Unity `MatchSubmissionGate.cs`, with snake_case
JSON names and all five 32-byte commitments encoded as CBOR byte strings. Domain:
`AKG:MATCH_SUMMARY:v1\0`. This defines a proposed core encoding reference; it does
not implement Unity's `ICanonicalMatchCodec` or align the separate backend replay
summary. Summary fields have fixed size; no events field or large-payload summary
is introduced. `WER-large-refs-10k` supplies the array stress reference instead.
No C#↔WASM marshaling or heap execution is established by these Rust/Python checks.

These vectors check serialization and digest compatibility for concrete
inputs. They do not establish executor identity, authorization, runtime policy
enforcement, or correct execution. This core export does not claim conformance to
the separate MMR vector schema, which requires an MMR profile reference.
