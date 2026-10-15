{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libxslt,
  asciidoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mktiupgrade";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "mktiupgrade";
    rev = finalAttrs.version;
    hash = "sha256-tSHcMEV8tKPNg4lpz30QGfv2u54378wBYu/Gs3fPw5c=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    asciidoc
    cmake
    libxslt.bin
  ];

  hardeningDisable = [ "format" ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.5)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    homepage = "https://knightos.org/";
    description = "Makes TI calculator upgrade files from ROM dumps";
    mainProgram = "mktiupgrade";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siraben ];
    platforms = lib.platforms.unix;
  };
})
