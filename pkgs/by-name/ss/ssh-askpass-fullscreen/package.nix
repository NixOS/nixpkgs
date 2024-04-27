{ lib
, stdenv
, autoreconfHook
, fetchFromGitHub
, gtk2
, openssh
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ssh-askpass-fullscreen";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "atj";
    repo = "ssh-askpass-fullscreen";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1GER+SxTpbMiYLwFCwLX/hLvzCIqutyvQc9DNJ7d1C0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    gtk2
    openssh
  ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/atj/ssh-askpass-fullscreen";
    broken = stdenv.isDarwin;
    description = "A small, fullscreen SSH askpass GUI using GTK+2";
    license = with lib.licenses; [ gpl2Plus ];
    mainProgram = "ssh-askpass-fullscreen";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
