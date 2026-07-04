{
  lib,
  cacert,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "proxy";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "proxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CAT05X9z8VBoDyZhVdMCUgpMtUe4wJvvROQc/sYHROs=";
  };
  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;
  cargoHash = "sha256-JXKqLM9rosaeCQP+UnY49FI6dpTEfd//jUhTEHoeKqU=";
  # `Result::unwrap()` on an `Err` value: Tls("platform verifier: unexpected error: No CA certificates were loaded from the system")
  nativeCheckInputs = [
    cacert
  ];
  checkFlags = lib.forEach [
    # require docker: Result::unwrap()` on an `Err` value: Client(Init(SocketNotFoundError("/var/run/docker.sock")))
    "tests::redis_store::redis_store_resolves_and_misses"
    "tests::sql_store::sql_store_resolves_and_misses"
    "tests::sql_store::sql_store_upsert_and_remove"
  ] (test: "--skip=${test}");
  meta = {
    description = "Multi-protocol e-mail migration proxy";
    longDescription = ''
       The migration proxy sits in front of one or more mail backends and decides, on a per-account basis, which backend a given connection belongs to. It terminates IMAP, POP3, ManageSieve, SMTP submission, SMTP/LMTP and HTTP (JMAP) sessions, identifies the account behind each connection from the credentials the client already presents, looks up the destination that account is assigned to, replays the authentication to that backend, and bridges the session. Because the routing decision is made from the existing credentials, no client reconfiguration is required: users keep the same server name, ports and passwords while the proxy routes them to the correct system.

      It is built for three scenarios: migrating from legacy servers (Dovecot, Cyrus and other IMAP/POP3/SMTP servers) onto Stalwart one mailbox at a time, migrating between Stalwart versions by running an old and a new deployment side by side, and acting as a cache-locality router in front of a Stalwart cluster so each account is consistently pinned to the same node.
    '';
    homepage = "https://github.com/stalwartlabs/proxy";
    changelog = "https://github.com/stalwartlabs/proxy/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.OR [
      lib.licenses.agpl3Only
      {
        fullName = "Stalwart Enterprise License 2.0 (SELv2) Agreement";
        url = "https://github.com/stalwartlabs/proxy/blob/main/LICENSES/LicenseRef-SEL.txt";
        free = false;
        redistributable = false;
      }
    ];
    mainProgram = "proxy";
    maintainers = with lib.maintainers; [
      debtquity
    ];
  };
})
