{
  lib,
  stdenv,
  callPackage,
}:

let
  version = "0.2.1";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Small, fast container runtime that speaks the Docker Engine API";
    homepage = "https://runkiri.com";
    changelog = "https://github.com/libracoder/kiri/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ imcvampire ];
    mainProgram = "kiri";
  };
in
# macOS needs a custom guest kernel and a binary signed with Apple's
# virtualization entitlement, neither of which can be produced in the sandbox.
callPackage (if stdenv.hostPlatform.isDarwin then ./darwin.nix else ./linux.nix) {
  inherit version meta passthru;
}
