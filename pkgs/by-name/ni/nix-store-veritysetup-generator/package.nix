{
  lib,
  rustPlatform,
  fetchFromGitHub,
  systemd,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nix-store-veritysetup-generator";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "nikstur";
    repo = "nix-store-veritysetup-generator";
    rev = finalAttrs.version;
    hash = "sha256-4VIPyhvPKRlEgX7roUMIyhSBqfrWPbbsdhyccxH8EIM=";
  };

  sourceRoot = "${finalAttrs.src.name}/rust";

  cargoHash = "sha256-nL9GiluLV12J/Kwkq2gAYmOWtPr6sG4ELoLj3UCgDtg=";

  env = {
    SYSTEMD_VERITYSETUP_PATH = "${systemd}/lib/systemd/systemd-veritysetup";
    SYSTEMD_ESCAPE_PATH = "${systemd}/bin/systemd-escape";
  };

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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nikstur ];
    mainProgram = "nix-store-veritysetup-generator";
  };
})
