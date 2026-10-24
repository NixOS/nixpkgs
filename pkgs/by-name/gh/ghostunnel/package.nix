{
  buildGo127Module,
  fetchFromGitHub,
  lib,
  nixosTests,
}:

buildGo127Module (finalAttrs: {
  pname = "ghostunnel";
  version = "1.11.5";

  src = fetchFromGitHub {
    owner = "ghostunnel";
    repo = "ghostunnel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nGnFuTZDCMAx4x0QPptYhv/UTO+opw97HIvaxqgQHPA=";
  };

  vendorHash = null;

  deleteVendor = true;

  patches = [
    # A flag for extra paths in the landlock sandbox.
    # Needed for config files in the store, for instance.
    # Not offered upstream yet.
    ./landlock-allow-read.patch
  ];

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
    nixos-no-nscd = nixosTests.ghostunnel-no-nscd;
    nixos-modular = nixosTests.ghostunnel-modular;
    nixos-modular-no-nscd = nixosTests.ghostunnel-modular-no-nscd;
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
    longDescription = ''
      On Linux, ghostunnel restricts itself with a landlock sandbox. The
      Nixpkgs build adds a `--landlock-allow-read` flag, which lets the sandbox
      read files and list directories in a further path. On NixOS, many paths
      in /etc are symlinks into the Nix store, so run ghostunnel with
      `--landlock-allow-read=/nix/store` there.
    '';
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
