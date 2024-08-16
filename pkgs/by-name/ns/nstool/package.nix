{
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nstool";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "jakcron";
    repo = "nstool";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-NGuosc4Vwc4WA+b7mtn2WyJFPI4xfx/vJsd8S58js+U=";
    fetchSubmodules = true;
  };

  preBuild = ''
    make deps
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -v bin/nstool $out/bin
  '';

  meta = {
    description = "General purpose reading/extraction tool for Nintendo Switch file formats";
    homepage = "https://github.com/jakcron/nstool";
    license = lib.licenses.mit;
    mainProgram = "nstool";
    maintainers = with lib.maintainers; [ diadatp ];
    platforms = lib.platforms.unix;
  };
})
