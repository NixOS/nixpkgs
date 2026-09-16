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
  version = "3.9.5";

  src = fetchFromGitHub {
    owner = "RuriOSS";
    repo = "ruri";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eiljz0atD2lmgl4emoCw9xWsqm/cXP8QEj7AfcyHaSE=";
  };

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
    downloadPage = "https://github.com/RuriOSS/ruri";
    changelog = "https://github.com/RuriOSS/ruri/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "ruri";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.dabao1955 ];
  };
})
