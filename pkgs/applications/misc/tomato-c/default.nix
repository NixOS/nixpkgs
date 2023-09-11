{ lib
, stdenv
, fetchFromGitHub
, libnotify
, makeWrapper
, mpv
, ncurses
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tomato-c";
  version = "unstable-2023-08-21";

  src = fetchFromGitHub {
    owner = "gabrielzschmitz";
    repo = "Tomato.C";
    rev = "6e43e85aa15f3d96811311a3950eba8ce9715634";
    hash = "sha256-RpKkQ7xhM2XqfZdXra0ju0cTBL3Al9NMVQ/oleFydDs=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "sudo " ""
    substituteInPlace notify.c \
      --replace "/usr/local" "${placeholder "out"}"
    substituteInPlace util.c \
      --replace "/usr/local" "${placeholder "out"}"
    substituteInPlace tomato.desktop \
      --replace "/usr/local" "${placeholder "out"}"
  '';

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    libnotify
    mpv
    ncurses
  ];

  installFlags = [
    "PREFIX=${placeholder "out"}"
    "CPPFLAGS=$NIX_CFLAGS_COMPILE"
    "LDFLAGS=$NIX_LDFLAGS"
  ];

  postFixup = ''
    for file in $out/bin/*; do
      wrapProgram $file \
        --prefix PATH : ${lib.makeBinPath [ libnotify mpv ]}
    done
  '';

  strictDeps = true;

  meta = {
    homepage = "https://github.com/gabrielzschmitz/Tomato.C";
    description = " A pomodoro timer written in pure C";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    mainProgram = "tomato";
    platforms = lib.platforms.unix;
  };
})
