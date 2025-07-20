{
  lib,
  rustPlatform,
  fetchFromGitHub,
  systemd,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-store-veritysetup-generator";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "nikstur";
    repo = "nix-store-veritysetup-generator";
    rev = version;
    hash = "sha256-kQ+mFBnvxmEH2+z1sDaehGInEsBpfZu8LMAseGjZ3/I=";
  };

  sourceRoot = "${src.name}/rust";

  cargoHash = "sha256-9DwED8X/RHjBCInm+VbzoeVSb28U+XIE2IjNAGon6+E=";

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

  meta = with lib; {
    description = "Systemd unit generator for a verity protected Nix Store";
    homepage = "https://github.com/nikstur/nix-store-veritysetup-generator";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ nikstur ];
    mainProgram = "nix-store-veritysetup-generator";
  };
}
