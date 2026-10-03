{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  asciidoc,
  libxslt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "patchrom";

  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "patchrom";
    rev = finalAttrs.version;
    hash = "sha256-m1UJsOyTP0PxJEcdJAJ/SFGQS2ut4M5Gz2aeOezBhHk=";
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
    description = "Patches jumptables into TI calculator ROM files and generates an include file";
    mainProgram = "patchrom";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siraben ];
    platforms = lib.platforms.unix;
  };
})
