{
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nstool";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "jakcron";
    repo = "nstool";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-az6AkBCO7Ew5jK/9qKQ65adwAKYf+H7QEvVI6LCXFS0=";
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
