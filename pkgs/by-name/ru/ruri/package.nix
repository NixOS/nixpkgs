{
  lib,
  stdenv,
  fetchFromGitHub,
  libcap,
  libseccomp,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ruri";
  version = "3.9.1";

  src = fetchFromGitHub {
    owner = "RuriOSS";
    repo = "ruri";
    tag = "v${finalAttrs.version}";
    hash = "sha256-stM4hSLdSqmYUZ/XBD3Y1GylrrGRISlcy8LN07HREpQ=";
  };

  patches = [
    ./cmake-install.patch
  ];

  buildInputs = [
    libcap
    libseccomp
  ];

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Self-contained Linux container implementation";
    homepage = "https://wiki.crack.moe/ruri";
    downloadPage = "https://github.com/Moe-hacker/ruri";
    changelog = "https://github.com/Moe-hacker/ruri/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "ruri";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.dabao1955 ];
  };
})
