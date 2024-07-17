{
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "bitwuzla";
    repo = "bitwuzla";
    rev = finalAttrs.version;
    hash = "sha256-ZEdV4ml1LwrYwscgOcL2gLx/ijPYqRktXMQH/Njh8OI=";
  };

  patches = [
    # fix parser on aarch64
    # remove on next release
    (fetchpatch {
      url = "https://github.com/bitwuzla/bitwuzla/commit/4d914aa5ec34076c37749f0cf6dce976ea510386.patch";
      hash = "sha256-gp+HEamOySjPXCC39tt5DIMdQqEew26a+M15sNdCmTM=";
    })
  ];

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

    (lib.strings.mesonEnable "testing" finalAttrs.doCheck)
  ];

  nativeCheckInputs = [ python3 ];
  checkInputs = [ gtest ];
  # two tests fail on darwin
  doCheck = stdenv.hostPlatform.isLinux;

  meta = {
    description = "A SMT solver for fixed-size bit-vectors, floating-point arithmetic, arrays, and uninterpreted functions";
    mainProgram = "bitwuzla";
    homepage = "https://bitwuzla.github.io";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ symphorien ];
  };
})
