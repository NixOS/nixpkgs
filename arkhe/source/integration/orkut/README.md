# arkhe-orkut

Local integration candidate; no API contract or relationship with orkut.com is
assumed. `propose` checks an access token and host-verified humanity evidence and
returns a sealed proposal for CommunityJoin or CommunityPost. The token, humanity
and optional content provenance appear only as typed digest references. The host
chooses its resource and minimum score (20 for the specification's sample policy).

The `HumanityVerifier` port must verify real Passport/ZK proof data. No fake score
or accepting production implementation is supplied. Evidence must bind the token's
subject and audience and be unexpired. A provenance digest is a reference, never
an automatically verified C2PA badge. Post content remains untrusted text; a UI must
escape/sanitize it for its output context.

`executor::Executor` reuses the existing Journal/Kernel ports and ContainmentGate:

1. Reserve operation identity and detect parameter conflicts or completed replay.
2. Bind the entire proposal snapshot to a worker validation record.
3. Require kernel admission and explicit governance module/operation permission.
4. Require host revalidation against current token/humanity/revocation state.
5. Mark DISPATCHED before the backend write.
6. Admit execution evidence and complete the journal.

Failure requires manual reconciliation; the executor does not retry uncertain
writes. Cancellation leaves the reservation/dispatch journal entry pending, which
also blocks automatic retry. Supply PgOperations for durable journaling and an
independent signed WorkerVerifier-backed kernel. The shared ports currently live
in arkhe-bugbounty; they are reused rather than introducing a divergent journal.
Analysis uses ContextKind::SourceReport as the existing generic snapshot slot;
its digest here describes the entire community proposal, not a bug report.

The backend and revalidator are mandatory host ports. No concrete upstream Orkut
write, Passport verification key, ZK circuit or production signing custody was
invented. Development governance continues to deny all these protected transitions.

```powershell
cargo test -p arkhe-orkut --locked
```

Tests use explicitly synthetic humanity/admission/backends. They verify credential
and humanity rejection, admitted execution, completed replay and a revalidation
failure before dispatch; they do not establish real upstream authorization.
