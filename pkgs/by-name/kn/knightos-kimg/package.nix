{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libxslt,
  asciidoc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kimg";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "KnightOS";
    repo = "kimg";
    rev = finalAttrs.version;
    hash = "sha256-gwauRch5l0GPdXAfEXd/HOjoln0pP7dgLUrAPKZABxA=";
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
    description = "Converts image formats supported by stb_image to the KnightOS image format";
    mainProgram = "kimg";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siraben ];
    platforms = lib.platforms.all;
  };
})
