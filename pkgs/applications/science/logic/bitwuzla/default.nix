{ stdenv
, fetchFromGitHub
, lib
, python3
, meson
, ninja
, git
, btor2tools
, symfpu
, gtest
, gmp
, cadical
, cryptominisat
, zlib
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "bitwuzla";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "bitwuzla";
    repo = "bitwuzla";
    rev = version;
    hash = "sha256-ZEdV4ml1LwrYwscgOcL2gLx/ijPYqRktXMQH/Njh8OI=";
  };

  strictDeps = true;

  nativeBuildInputs = [ meson pkg-config git ninja ];
  buildInputs = [
    cadical
    cryptominisat
    btor2tools
    symfpu
    gmp
    zlib
  ];

  mesonFlags = [ "-Ddefault_library=shared" ];

  nativeCheckInputs = [ python3 ];
  checkInputs = [ gtest ];
  # two tests fail on darwin and 3 on aarch64-linux
  doCheck = stdenv.hostPlatform.isLinux && (!stdenv.hostPlatform.isAarch64);

  meta = with lib; {
    description = "A SMT solver for fixed-size bit-vectors, floating-point arithmetic, arrays, and uninterpreted functions";
    mainProgram = "bitwuzla";
    homepage = "https://bitwuzla.github.io";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ symphorien ];
  };
}
