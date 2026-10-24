{
  buildGo127Module,
  fetchFromGitHub,
  lib,
  nixosTests,
}:

buildGo127Module (finalAttrs: {
  pname = "ghostunnel";
  version = "1.11.4";

  src = fetchFromGitHub {
    owner = "ghostunnel";
    repo = "ghostunnel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ilfmFBvXDNQiynUOwI4+LUSsAnq7MvPv125rAdM+F8Y=";
  };

  vendorHash = "sha256-jFOxwk03FOX+nDkcU8CTj13+z6pl+A/VFf1wirGVY1w=";

  deleteVendor = true;

  checkFlags = [
    # These tests don't exist for Linux, and on Darwin they attempt to use the macOS Keychain
    # which doesn't work from a nix build. Presumably other platform implementations of the
    # certstore would have similar issues, so it probably makes sense to skip them in
    # general wherever they are available.
    "-skip=^Test(ImportDelete|Signer|Certificate)(RSA|ECDSA|EC)$"
    # These tests should work in the nix build, since they only use local networking. For some
    # reason they aren't working though.
    "-skip=^TestACMEInitialIssuance"
  ];

  passthru.tests = {
    nixos = nixosTests.ghostunnel;
    podman = nixosTests.podman-tls-ghostunnel;
  };

  passthru.services.default = {
    imports = [
      (lib.modules.importApply ./service.nix { })
    ];
    ghostunnel.package = finalAttrs.finalPackage;
  };

  meta = {
    description = "TLS proxy with mutual authentication support for securing non-TLS backend applications";
    homepage = "https://github.com/ghostunnel/ghostunnel#readme";
    changelog = "https://github.com/ghostunnel/ghostunnel/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      roberth
      mjm
    ];
    mainProgram = "ghostunnel";
  };
})
