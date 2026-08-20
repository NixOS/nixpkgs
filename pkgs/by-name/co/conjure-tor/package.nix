{
  lib,
  buildGoModule,
  fetchFromGitLab,
  nix-update-script,
}:
buildGoModule {
  pname = "conjure-tor";
  version = "0-unstable-2026-01-13";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    owner = "tpo";
    repo = "anti-censorship/pluggable-transports/conjure";
    rev = "0090962226b82aa4a8fc38506f9b98de67d0781e";
    hash = "sha256-WGyzoc03QqPtLiZrUMCRMlPNm6JVSOnZv2a8KeZt7P4=";
  };

  vendorHash = "sha256-6m/qNRrbWMREdDK/VpDAILynplyzbicdplxDrcTipSc=";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/conjure";
    description = "Refraction networking system that routes traffic to endpoints in an ISP's unused IP address space";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mksafavi ];
  };
}
