{
  lib,
  rustPlatform,
  fetchFromGitHub,
  systemd,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nix-store-veritysetup-generator";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "nikstur";
    repo = "nix-store-veritysetup-generator";
    tag = finalAttrs.version;
    hash = "sha256-xZNUqbI6a+RJfaJXBQYf5pAJNIiQdJ1PybeDR0TAfjk=";
  };

  sourceRoot = "${finalAttrs.src.name}/rust";

  cargoHash = "sha256-ZTTHeScm4bSWfKHNgmfsxuBS6zTgn7OpFGiBYo0vcfY=";

  nativeCheckInputs = [
    systemd
  ];

  # Use a fake path in tests so that they are not dependent on specific Nix
  # Store paths and thus don't break on different Nixpkgs invocations. This is
  # relevant so that this package can be compiled on different architectures.
  preCheck = ''
    export SYSTEMD_VERITYSETUP_PATH="systemd-veritysetup";
  '';

  stripAllList = [ "bin" ];

  passthru.tests = {
    inherit (nixosTests) nix-store-veritysetup;
  };

  meta = {
    description = "Systemd unit generator for a verity protected Nix Store";
    homepage = "https://github.com/nikstur/nix-store-veritysetup-generator";
    changelog = "https://github.com/nikstur/nix-store-veritysetup-generator/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nikstur ];
    mainProgram = "nix-store-veritysetup-generator";
  };
})
