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
  version = "3.9.3";

  src = fetchFromGitHub {
    owner = "RuriOSS";
    repo = "ruri";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cFHbsaZwxu2ABAln5hGDSOib11M/1/4OeXz2EKXFlZI=";
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
