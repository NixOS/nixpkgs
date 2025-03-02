{
  lib,
  buildGoModule,
  fetchFromGitLab,
  nix-update-script,
}:
buildGoModule {
  pname = "conjure-tor";
  version = "0-unstable-2024-11-11";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    owner = "tpo";
    repo = "anti-censorship/pluggable-transports/conjure";
    rev = "a773daab19928f37caf2ec4181f0da2e0d20d35a";
    hash = "sha256-WC9QEgwhu7ynf2p8SXzMf8JNp6ZzF4S9Lk2SjUWj2lU=";
  };

  vendorHash = "sha256-vdcpNYa2gjacK0DMQ6VP9kX6f10JOHn8+Wr1Ql+lI7o=";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/conjure";
    description = "Refraction networking system that routes traffic to endpoints in an ISP's unused IP address space";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mksafavi ];
  };
}
