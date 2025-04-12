{
  lib,
  stdenv,
  fetchFromGitHub,
  libcap,
  libseccomp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ruri";
  version = "3.8";

  src = fetchFromGitHub {
    owner = "Moe-hacker";
    repo = "ruri";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = false;
    sha256 = "sha256-gf+WJPGeLbMntBk8ryTSsV9L4J3N4Goh9eWBIBj5FA4=";
  };

  buildInputs = [
    libcap
    libseccomp
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 ruri $out/bin/ruri
    runHook postInstall
  '';

  meta = {
    description = "Self-contained Linux container implementation";
    homepage = "https://wiki.crack.moe/ruri";
    downloadPage = "https://github.com/Moe-hacker/ruri";
    changelog = "https://github.com/Moe-hacker/ruri/releases/tag/v${finalAttrs.version}";
    mainProgram = "ruri";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.dabao1955 ];
  };
})
