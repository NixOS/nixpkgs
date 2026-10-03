{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "redir";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "redir";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wVs8Tqr3o4WU1bSnAhc/BUQY3zzEB5Gfu7wDPGIAxI4=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "TCP port redirector for UNIX";
    homepage = "https://github.com/troglobit/redir";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "redir";
  };
})
