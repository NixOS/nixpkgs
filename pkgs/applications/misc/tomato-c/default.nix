{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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

  patches = [
    # Adds missing function declarations required by newer versions of clang.
    (fetchpatch {
      url = "https://github.com/gabrielzschmitz/Tomato.C/commit/ad6d4c385ae39d655a716850653cd92431c1f31e.patch";
      hash = "sha256-3ormv59Ce4rOmeyL30QET3CCUIOrRYMquub+eIQsMW8=";
    })
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "sudo " ""
    # Need to define _ISOC99_SOURCE to use `snprintf` on Darwin
    substituteInPlace config.mk \
      --replace-fail -D_POSIX_C_SOURCE -D_ISOC99_SOURCE
    substituteInPlace notify.c \
      --replace-fail "/usr/local" "${placeholder "out"}"
    substituteInPlace util.c \
      --replace-fail "/usr/local" "${placeholder "out"}"
    substituteInPlace tomato.desktop \
      --replace-fail "/usr/local" "${placeholder "out"}"
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

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  installFlags = [
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
