{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libcxx,
  zlib,
}:
let
  version = "0.30.0";
in
stdenv.mkDerivation {
  pname = "splitcode";
  inherit version;

  src = fetchFromGitHub {
    owner = "pachterlab";
    repo = "splitcode";
    rev = "v${version}";
    hash = "sha256-g38pJFP9uA2P5ktogAPXKgPtsEJn5vtnK5HClqqezmg=";
  };

  patches = [ ./add-stdint.patch ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libcxx
    zlib
  ];

  doCheck = true;
  checkPhase = ''
    mkdir func_tests
    cp $src/func_tests/* ./func_tests/
    bash ./func_tests/runtests.sh
  '';

  meta = {
    description = "Tool for flexible, efficient parsing, interpreting, and editing of technical sequences in sequencing reads";
    homepage = "https://github.com/pachterlab/splitcode";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ zimward ];
    mainProgram = "splitcode";
  };
}
