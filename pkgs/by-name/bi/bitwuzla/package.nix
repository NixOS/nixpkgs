{
  stdenv,
  fetchFromGitHub,
  lib,
  python3,
  meson,
  ninja,
  git,
  btor2tools,
  symfpu,
  gtest,
  gmp,
  cadical,
  cryptominisat,
  zlib,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bitwuzla";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "bitwuzla";
    repo = "bitwuzla";
    rev = finalAttrs.version;
    hash = "sha256-xO9+hixboGaCAIi01sWuIYtPamIwUpiTujmOD60NEm0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    pkg-config
    git
    ninja
  ];
  buildInputs = [
    cadical
    cryptominisat
    btor2tools
    symfpu
    gmp
    zlib
  ];

  mesonFlags = [
    # note: the default value for default_library fails to link dynamic dependencies
    # but setting it to shared works even in pkgsStatic
    "-Ddefault_library=shared"

    (lib.strings.mesonEnable "testing" finalAttrs.finalPackage.doCheck)
  ];

  nativeCheckInputs = [ python3 ];
  checkInputs = [ gtest ];
  # two tests fail on darwin
  doCheck = stdenv.hostPlatform.isLinux;

  meta = {
    description = "SMT solver for fixed-size bit-vectors, floating-point arithmetic, arrays, and uninterpreted functions";
    mainProgram = "bitwuzla";
    homepage = "https://bitwuzla.github.io";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ symphorien ];
  };
})
