{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  asciidoc,
  libxslt,
}:

stdenv.mkDerivation rec {
  pname = "kpack";

  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "kpack";
    rev = version;
    sha256 = "1l6bm2j45946i80qgwhrixg9sckazwb5x4051s76d3mapq9bara8";
  };

  strictDeps = true;

  nativeBuildInputs = [
    asciidoc
    cmake
    libxslt.bin
  ];

  hardeningDisable = [ "fortify" ];

  meta = with lib; {
    homepage = "https://knightos.org/";
    description = "Tool to create or extract KnightOS packages";
    mainProgram = "kpack";
    license = licenses.lgpl2Only;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.unix;
  };
}
