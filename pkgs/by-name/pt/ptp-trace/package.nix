{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "ptp-trace";
  version = "0.20"; # keep in sync with liana

  src = fetchFromGitHub rec {
    owner = "holoplot";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3VkI+IkxGArd5cZD/HsC6klHsS5/qdbHS308PWqb1UA=";
  };

  cargoHash = "sha256-A25e/CgHSwMokd0AKBgnHJJ5EHXJKCHuDXXfOBYzAuo=";

  meta = {
    mainProgram = "ptp-trace";
    description = "";
    homepage = "";
    license = lib.licenses.gpl2;
    maintainers = [
      lib.maintainers.dbalan
    ];
    platforms = lib.platforms.unix;
  };
}
