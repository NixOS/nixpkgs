{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdate";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "ChristophBerg";
    repo = "sdate";
    rev = finalAttrs.version;
    hash = "sha256-jkwe+bSBa0p1Xzfetsdpw0RYw/gSRxnY2jBOzC5HtJ8=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    homepage = "https://www.df7cb.de/projects/sdate";
    description = "Eternal september version of the date program";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ edef ];
    platforms = lib.platforms.all;
    mainProgram = "sdate";
  };
})
