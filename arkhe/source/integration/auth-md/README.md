# arkhe-auth-md

Local implementation candidate, not a deployed OAuth server or a claim of full
auth.md interoperability. The protocol's structured discovery remains authoritative.

`token` implements a pinned Ed25519 JWT profile: issuer/key/audience/client checks,
verified email, fresh authentication, bounded lifetime, exact scopes, provider
registration replay detection, token revocation and registration revocation.
Provider JWTs can omit the Arkhe service-local `scope` and `registration_id` fields.
Only the email identity path is supported; phone-only providers require an adapter.
Unknown JWT payload claims are permitted; algorithm/type/key headers are strict.

`service::Service` implements provider registration → service-signed identity
assertion → scoped access token. Service assertions can be re-exchanged until expiry.
Bearer revocation leaves the assertion valid; provider-subject revocation kills
all derived assertions and tokens. Provider principals use issuer + subject, never
silent email linking. Host-approved scopes cannot be supplied by agent input.

`claims::PendingClaim` implements authenticated confirmation, a random six-digit
code, ten-minute expiry, five-attempt lockout and single consumption. The host must
bind it to an unguessable claim token and a real authenticated session. Never use
an agent-supplied subject or email as authenticated session data.

`registration_record` produces an unsigned WER candidate from a verified access
token. Its digest binds the bearer without storing the bearer. Only a separately
trusted signer and kernel admission may turn that candidate into admitted evidence.

The `host` feature enables OS-random claim/service support. Disable default features
for offline WebAssembly verification. `verify_auth_assertion` in arkhe-verify-wasm
checks signatures/claims only; it cannot establish live revocation or replay state.

```powershell
cargo test -p arkhe-auth-md --locked
cargo check -p arkhe-verify-wasm --target wasm32-unknown-unknown --locked
```

Before exposing a service, provide durable atomic replay/claim/revocation storage,
HTTP OAuth endpoints and error envelopes, session authentication, CSRF protection,
rate limits, key custody/rotation and authenticated SET delivery. Current state is
process-local and must not be used across restarts or replicas as a production
authorization authority. No provider JWKS is fetched and no DID grants implicit trust.

Sources checked 2026-10-17: [overview](https://workos.com/auth-md/docs),
[app contract](https://workos.com/auth-md/docs/apps),
[discovery](https://workos.com/auth-md/docs/auth-md).
