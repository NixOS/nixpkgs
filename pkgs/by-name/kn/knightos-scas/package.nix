{
  fetchFromGitHub,
  lib,
  stdenv,
  cmake,
  buildPackages,
  asciidoc,
  libxslt,
}:

let
  isCrossCompiling = stdenv.hostPlatform != stdenv.buildPlatform;
in

stdenv.mkDerivation rec {
  pname = "scas";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "scas";
    rev = version;
    sha256 = "sha256-JGQE+orVDKKJsTt8sIjPX+3yhpZkujISroQ6g19+MzU=";
  };

  cmakeFlags = [ "-DSCAS_LIBRARY=1" ];
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "TARGETS scas scdump scwrap" "TARGETS scas scdump scwrap generate_tables" \
      --replace-fail "cmake_minimum_required(VERSION 2.8.5)" "cmake_minimum_required(VERSION 3.10)"
  '';
  strictDeps = true;

  depsBuildBuild = lib.optionals isCrossCompiling [ buildPackages.knightos-scas ];
  nativeBuildInputs = [
    asciidoc
    libxslt.bin
    cmake
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [
      "-Wno-error=implicit-function-declaration"
    ]
  );

  postInstall = ''
    cd ..
    make DESTDIR=$out install_man
  '';

  meta = with lib; {
    homepage = "https://knightos.org/";
    description = "Assembler and linker for the Z80";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.all;
  };
}
