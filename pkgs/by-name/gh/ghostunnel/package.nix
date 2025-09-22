{
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  lib,
  nixosTests,
  ghostunnel,
  writeScript,
  runtimeShell,
}:

buildGoModule rec {
  pname = "ghostunnel";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "ghostunnel";
    repo = "ghostunnel";
    rev = "v${version}";
    hash = "sha256-NnRm1HEdfK6WI5ntilLSwdR2B5czG5CIcMFzl2TzEds=";
  };

  vendorHash = "sha256-vP8OtjpYNMm1KkNfD3pmNrHh3HRy1GkzUbfLKWKhHbo=";

  deleteVendor = true;

  # These tests don't exist for Linux, and on Darwin they attempt to use the macOS Keychain
  # which doesn't work from a nix build. Presumably other platform implementations of the
  # certstore would have similar issues, so it probably makes sense to skip them in
  # general wherever they are available.
  checkFlags = [ "-skip=^Test(ImportDelete|Signer|Certificate)(RSA|ECDSA|EC)$" ];

  passthru.tests = {
    nixos = nixosTests.ghostunnel;
    podman = nixosTests.podman-tls-ghostunnel;
  };

  passthru.services.default = {
    imports = [
      (lib.modules.importApply ./service.nix {
        inherit writeScript runtimeShell;
      })
    ];
    ghostunnel.package = ghostunnel; # FIXME: finalAttrs.finalPackage
  };

  meta = {
    description = "TLS proxy with mutual authentication support for securing non-TLS backend applications";
    homepage = "https://github.com/ghostunnel/ghostunnel#readme";
    changelog = "https://github.com/ghostunnel/ghostunnel/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      roberth
      mjm
    ];
    mainProgram = "ghostunnel";
  };
}
