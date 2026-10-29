# AKG-IDENTITY-0002 v0.1 — Verifier roster and identity-evidence admission

Status: **DRAFT — code landed, Kani harness pending execution** (see §6).

Module: `arkhe_wormgraph::roster` (`src/roster.rs`)
Companion: AKG-IDENTITY-0001 (the `IdentityNode` this roster authorizes).

> The `IdentityNode` proves that *a key* read the chain and verified the
> social proofs at `verified_at`. It does not prove that the key was
> *authorized* to say so. Trust in the verifier is a governance decision,
> not a cryptographic property of the node. This document is that decision.

## 1. Model

- `RosterEntry { verifier_public_key, role, valid_from, valid_until }`
  with `covers(at)` a closed window (`None` expiry = no end).
- `VerifierRole` = Operator | Auditor | Regulator — declarations of
  function, never permissions; what a role may do is decided downstream
  (ContainmentGate, ReviewRouter).
- `GovernanceRoster { version, quorum_threshold, entries, approvals }`,
  `CanonicalEncode` domain `AKG:ROSTER:v1\0`, unsigned projection excludes
  `approvals`.
- `RosterApproval` = Ed25519 signature by a roster member over the unsigned
  canonical roster bytes.

## 2. Authority and succession

- **Genesis is an out-of-band trust anchor**: `genesis(entries, quorum,
  approvals)` requires every signer to be one of the entries being admitted
  (self-anchored). Whoever configures genesis decides the initial authority
  set; nothing in this module derives or validates that choice.
- **Succession is on-chain**: `succeed(entries, quorum, approvals, now)`
  requires a quorum of the *previous* roster's members active at `now`;
  the new version is `parent.version + 1`. Removed keys stop resolving;
  new keys join from `valid_from`.
- `verify(parent, now)` re-derives everything a reader of a stored roster
  must check: well-formed entries (no duplicate keys, sane windows), valid
  approval signatures, signers in the authority set (self for genesis,
  parent for succession), no duplicate signers, quorum met, version
  succession. Violations are enumerated in `RosterViolation` and fail
  closed.

## 3. Anchoring

```
kind           = "ArkheGovernanceRoster"
record_hash    = roster.digest()
payload_digest = roster.digest()
subject        = BLAKE3(AKG:ROSTER:LINEAGE:v1\0, "arkhe-verifier-roster")
causal_parents = [previous version's roster digest]
```

One subject, one lineage: the WormGraph holds the full amendment history,
and each version's parent is reachable through `causal_parents`. Consumers
reconstruct the chain (`version == parent.version + 1` enforced) rather
than trusting the latest version in isolation.

## 4. `identity_proven` — the consumer

```
identity_proven(node, readout, checks, roster, parent_roster, now)
  → Result<VerifierRole, IdentityProvenanceError>
```

1. `roster.verify(parent_roster, now)` — invalid roster refuses everything.
2. `roster.entry_for(node.verifier_public_key)` — **absent key ⇒
   `NotInRoster`**: a node signed by someone outside the roster proves
   nothing, no matter how well-formed.
3. `entry.covers(now)` — expired/not-yet-active verifier ⇒
   `MembershipWindow`.
4. `node.invariant_holds(readout, checks, resolved_key, now)` — the
   AKG-IDENTITY-0001 invariant, now against the roster-resolved key.
5. Returns the verifier's `VerifierRole`. Granting authorization from that
   role is the ContainmentGate's job:

```
ProtectedTransitionAllowed ⇒ VerificationCompleted ∧ IdentityProven
```

## 5. Relation to AKG-IDENTITY-0001 (dependency, documented)

`IdentityNode` alone: *someone signed*. With this roster: *an authorized,
active verifier signed, and the full invariant holds*. Neither ever says
*the signer may act* — roles name function; policy decides action. The
node also never replaces chain verification: it attests that a verifier
read the claim at `verified_at`; a consumer may always re-read the chain
itself (option 2 in the review) — the roster makes that a choice, not a
necessity.

## 6. Proof obligations

Concrete tests (passing): genesis quorum admission and fail-closed
taxonomy (below-quorum, foreign signer, corrupted signature), succession
(old-roster quorum, version chaining, removed keys stop resolving),
`identity_proven` end-to-end — **including the negative cases: a node
signed outside the roster is rejected (`NotInRoster`) and a node by an
expired verifier is rejected (`MembershipWindow`)** — tampered node
refused through the consumer, lineage envelope binding, and seeded
property tests (512 rounds: `resolve` ≡ membership window; 256 rounds:
every seeded roster corruption refused).

Kani (written, not executed in the authoring environment):
`resolve_is_exactly_the_membership_window` — fully symbolic `at: i64`,
no crypto on the path: `resolve(k1, at) ⇔ at ≥ 100`,
`resolve(k2, at) ⇔ 200 ≤ at ≤ 300`, absent key always `None`.

## 7. Honest limits (τ)

| Claim | τ |
|:---|:---|
| Roster quorum/succession logic is fail-closed over modeled inputs | LEMMA once Kani runs; currently concrete + seeded property tests |
| `identity_proven` refuses out-of-roster and expired-verifier nodes | LEMMA — negative tests pass |
| Genesis authority is legitimate | CONJECTURE — out-of-band by design; this module cannot and must not decide it |
| Roles grant permissions | REFUTED by design — declarations only; enforcement is downstream |
| Full amendment-chain verification on every consume | The API takes `parent_roster`; walking the full WormGraph lineage is the caller's (unimplemented) job — PENDING |
