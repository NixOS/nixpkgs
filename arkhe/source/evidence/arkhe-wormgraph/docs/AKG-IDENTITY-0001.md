# AKG-IDENTITY-0001 v0.1 — Thurin-backed identity evidence nodes

Status: **DRAFT — code landed, Kani harnesses pending execution** (`cargo kani`
not available in the authoring environment; see §7).

Module: `arkhe_wormgraph::identity` (`src/identity.rs`)
Parent doctrine: identity answers *who holds this key*; it never answers
*what that key may do*. Authorization stays with the ContainmentGate and
IntentBinding:

```
ProtectedTransitionAllowed ⇒ VerificationCompleted ∧ IdentityProven
```

This document specifies the `IdentityProven` input only.

## 1. Scope

Anchor a verified [Thurin.id](https://docs.thurin.id/) on-chain claim
(PGP key ↔ Ethereum address ↔ bidirectional social proofs) as a WormGraph
evidence envelope, attested by an Arkhe-side Ed25519 verifier.

Non-goals:

- No authorization, policy, or role enforcement. Thurin records
  (`thurin.affiliation`, `thurin.successor`, …) are mirrored as declarations;
  consuming them as anything stronger is out of scope.
- No PGP cryptography in this module. The claim readout and the social-proof
  check results arrive as untrusted inputs from the reader
  (`eth_call` + openpgp.js client-side verification, per Thurin's docs:
  the contract does not check PGP signatures; readers do).

## 2. Data model

| Type | Role |
|:---|:---|
| `ThurinClaimReadout` | Untrusted `eth_call` result: address, registry index, armored key bytes, fingerprint, raw records |
| `ProofCheck` | One client-side bidirectional proof check (`proof@thurin.id` notation ∥ platform `thurin-id=openpgp4fpr:FPR` line) plus its verdict |
| `SocialProof` | Recorded proof: provider, account id, `bidirectional_digest` |
| `ThurinRecord` | Mirrored record: name, `value_digest` |
| `IdentityNode` | The evidence payload (§4 projection) |
| `identity_envelope` | Wraps a node in an `EvidenceEnvelope` |

Providers mirror Thurin's proof set: GitHub, DNS, Farcaster, Mastodon, Codeberg.

## 3. Admission boundary

`IdentityNode::admit(readout, checks, verifier_key, now)` fails closed:
malformed address (0x + 40 hex) or fingerprint (40/64 hex, v4/v6), an empty
proof set, or any `ProofCheck.verified == false` refuses the node. On success
every stored field is either derived from the inputs (digests) or set by the
verifier (`verified_at = now`, Ed25519 signature over the unsigned canonical
bytes). The node never stores chain-claimed timestamps.

Domain separation (BLAKE3 via `Digest32::blake3`):

```
AKG:IDENTITY:BIDIRECTIONAL:v1\0   provider tag ∥ notation ∥ 0x00 ∥ platform
AKG:IDENTITY:PROOFBUNDLE:v1\0     concat of bidirectional digests
AKG:IDENTITY:ARMORED:v1\0         armoredKey(address, index) bytes
AKG:IDENTITY:RECORDVALUE:v1\0     per-record raw value
AKG:IDENTITY:SUBJECT:v1\0         fingerprint ∥ address
AKG:IDENTITY:v1\0                 object digest (CanonicalEncode)
```

## 4. Canonical encoding

`CanonicalEncode` (AKG-CBOR-v1) with unsigned projection covering all fields
except `verifier_signature` — hashes identify content, admission establishes
provenance. New byte-typed fields registered in `arkhe-core` `canonical.rs`:
`armored_key_digest`, `bidirectional_digest`, `value_digest`, `proof_digest`,
`verifier_public_key`, `verifier_signature`. No existing field encoding
changes.

## 5. Invariant

`IdentityNode::invariant_holds(node, readout, checks, expected_verifier, now)`
re-derives everything from the same untrusted inputs plus the governance
roster key:

1. **WellFormed** — address and fingerprint formats.
2. **ClaimBinding** — fingerprint, address and `registry_index` equal the
   readout's: the node names the exact claim it summarises.
3. **ArmoredBinding** — `armored_key_digest == BLAKE3(ARMORED, readout.armored_key)`.
4. **ProofsVerified** — ≥ 1 check, every check verified, every recorded proof
   matches its evidence lines (provider, account, recomputed digest).
5. **ProofBundleBinding** — `proof_digest` matches the recomputed bundle.
6. **RecordsBinding** — mirrored records match the readout exactly.
7. **Freshness** — `verified_at <= now`.
8. **VerifierBinding** — `verifier_public_key` equals the expected roster key.
9. **SignatureValid** — Ed25519 over the unsigned canonical bytes verifies.

(Clause 2 was added after a seeded property test showed a format-valid
fingerprint/index swap passed the original eight clauses — the reader-side
re-derivation must bind the node to the exact claim, not just to digests.)

*"If the identity node exists in the WormGraph, the proof was verified against
the key and the account at `verified_at`"* is realized as: the node is only
committed through `admit`, `admit` only produces invariant-satisfying nodes,
and the WormGraph's content addressing (`record_hash == payload_digest`,
identical-hash/different-envelope refused) pins the payload thereafter.

## 6. Envelope anchoring

```
kind          = "ArkheIdentityNode"
record_hash   = node.digest()
payload_digest= node.digest()
subject       = BLAKE3(SUBJECT, fingerprint ∥ address)
causal_parents= caller-supplied (previous node for the same subject:
                key rotation / thurin.successor chains)
```

## 7. Proof obligations

Concrete tests (`cargo test -p arkhe-wormgraph identity` — passing):
admission soundness, fail-closed taxonomy, tamper detection per clause,
digest determinism and input sensitivity, envelope binding, WormGraph
anchoring idempotence and collision refusal, plus seeded property tests
(512 input mutations, 512 node corruptions, deterministic xorshift64*
generator, no new dependencies): every semantic input mutation is either
refused by `admit` or yields a node that fails the invariant against the
untampered context; every seeded node corruption is detected.

Kani harnesses (`#[cfg(kani)]`, `cargo kani -p arkhe-wormgraph` — written,
**not yet executed** in this environment; Kani is not installed here):

- `admit_is_sound_and_fails_closed` — symbolic tamper selector over the
  untrusted inputs; `Ok(node) ⇒ node satisfies the invariant against the
  untampered context ∧ tamper == None`, and every tamper is rejected.
- `tampered_nodes_violate_the_invariant` — each node-level deviation
  (swapped digest, future timestamp, corrupted signature, foreign key,
  dropped proof) is caught.
- `envelope_binds_identity_payload` — `record_hash == payload_digest ==
  node.digest()`.

Harness design: crypto artifacts are concrete (executed concretely under
Kani); the symbolic space is the tamper selector. This proves the admission
logic, not PGP or Ed25519 themselves.

## 8. Honest limits (τ)

| Claim | τ |
|:---|:---|
| Thurin claims/proofs behave as described | LEMMA — per docs.thurin.id (contracts.md, guides/proofs.md, records.md, crops.md), not independently executed against mainnet |
| `admit`/`invariant_holds` are sound and fail-closed over the modeled inputs | LEMMA once the Kani harnesses run; currently backed by concrete + seeded property tests |
| This module gives Arkhe the missing identity primitive | CONJECTURE until a governance consumer resolves principals through it |
| Records (`thurin.affiliation` etc.) carry roles | Declaration only — no enforcement, no quorum; enforcement stays in Arkhe |
| PGP ↔ Ed25519/BLAKE3 key-model fit | Thurin is PGP-centric; the node digests PGP material with BLAKE3 and attests with Ed25519, but no key-model unification is attempted |

**Dependency, documented:** this node proves that *a verifier* read the
chain and verified the proofs at `verified_at` — not that the verifier was
authorized, and not that the chain is true. Authorization of verifiers is
the roster's job (AKG-IDENTITY-0002, `roster.rs`, consumer
`identity_proven`); transition authorization remains the ContainmentGate's
job. Genesis roster authority is out-of-band by design.
