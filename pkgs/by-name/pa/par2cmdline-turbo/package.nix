{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "par2cmdline-turbo";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "animetosho";
    repo = "par2cmdline-turbo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Cz1VXWEVU93Qt2bNscWWX+71aWb6F7997rBYtjlip1A=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/animetosho/par2cmdline-turbo";
    description = "par2cmdline × ParPar: speed focused par2cmdline fork";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.proglottis ];
    platforms = lib.platforms.all;
    mainProgram = "par2";
  };
})
