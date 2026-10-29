# arkhe-depin

First executable slice of the proposed DePIN integration: `GensynAdapter` and
`CompositeProof`, using the checkout's `Digest32` and `arkhe-verify-core` MMR profile.

Run `cargo test -p arkhe-depin` from the workspace root.

The Verde DTO is a proposed integration schema, **not an authenticated upstream
wire format**. The fixture is synthetic and its signature is deliberately fake.
Normalization validates structure and produces deterministic typed JSON bytes;
it does not verify the referee signature or the arbitration result. This encoding
is not general-purpose canonical JSON: alternate JSON representations must first
be decoded into the DTO and normalized.

`CompositeProof::anchor` commits all normalized receipt fields and optional opaque
hardware evidence. `verify` recomputes that commitment and checks inclusion offline
against a separately trusted `Checkpoint` (root and leaf count). A checkpoint
carried inside an untrusted proof is insufficient to establish authenticity.
Proofs refer to the snapshot at creation; later appends do not refresh old proofs.
The in-memory builder retains all leaves and is intended for integration tests and
small batches, not persistent production storage. It does not claim a leaf position.

Inclusion proves committed bytes, not physical hardware, a real scene, correct
computation, or authenticated provider claims. Hardware evidence is committed but
not validated or cryptographically bound by a TEE to this receipt. NRAS/PPCIE,
Filecoin, Helium, Vangrid, slashing, and kernel admission policy are not implemented
in this slice. No permissive verification stubs are supplied.

Real Verde interoperability remains pending: obtain a provenance-backed receipt,
confirm the upstream schema and signed transcript, configure referee trust, and
add signature verification and real fixture tests before claiming that integration.
