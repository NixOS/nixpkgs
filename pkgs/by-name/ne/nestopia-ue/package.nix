{ lib
, SDL2
, alsa-lib
, autoconf-archive
, autoreconfHook
, fetchFromGitHub
, fltk
, libGL
, libGLU
, libao
, libarchive
, libepoxy
, makeWrapper
, pkg-config
, stdenv
, unzip
, wrapGAppsHook
, xdg-utils
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nestopia";
  version = "1.52.0";

  src = fetchFromGitHub {
    owner = "0ldsk00l";
    repo = "nestopia";
    rev = finalAttrs.version;
    hash = "sha256-kd5hZ88fCLL8ysGMj7HsrSA7eCI5SL2xxiRXJiZqBZ8=";
  };

  buildInputs = [
    SDL2
    alsa-lib
    fltk
    libepoxy

    libGLU
    libGL
    libarchive
    libao
    xdg-utils
  ];

  nativeBuildInputs = [
    SDL2
    autoconf-archive
    autoreconfHook
    fltk
    pkg-config
    makeWrapper
    wrapGAppsHook
    unzip
  ];

  strictDeps = true;

  preInstall = ''
    mkdir -p $out/{bin,share/nestopia}
  '';

  preFixup = ''
     for f in $out/bin/*; do
       wrapProgram $f \
         --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share"
     done
  '';

  meta = {
    homepage = "http://0ldsk00l.ca/nestopia/";
    description = "Cross-platform Nestopia emulator core with a GUI";
    changelog = "https://raw.githubusercontent.com/0ldsk00l/nestopia/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    mainProgram = "nestopia";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
