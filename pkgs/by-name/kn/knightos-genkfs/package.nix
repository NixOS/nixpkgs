{
  lib,
  stdenv,
  fetchFromGitHub,
  asciidoc,
  cmake,
  libxslt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "genkfs";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "genkfs";
    rev = finalAttrs.version;
    hash = "sha256-t3n14FFpqUTSN/5l+Ae5K2RoZY6UV4kLWOOsJVqLoDg=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    asciidoc
    libxslt.bin
    cmake
  ];

  hardeningDisable = [ "format" ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.5)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    homepage = "https://knightos.org/";
    description = "Utility to write a KFS filesystem into a ROM file";
    mainProgram = "genkfs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siraben ];
    platforms = lib.platforms.all;
  };
})
