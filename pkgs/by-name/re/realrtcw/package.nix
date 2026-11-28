{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,

  ffmpeg,
  sdl3,
  opusfile,
  libvorbis,
  zlib,
  openal-soft,
  freetype,
  libjpeg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "realrtcw";
  version = "5.44c";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "wolfetplayer";
    repo = "RealRTCW";
    tag = finalAttrs.version;
    hash = "sha256-L1/Fk8AHoGNvrOJrMASHztm2SwOFpq2LPRR0lPBO+0c=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    ffmpeg
    sdl3
    opusfile
    libvorbis
    zlib
    openal-soft
    freetype
    libjpeg
  ];

  NIX_LDFLAGS = "-lSDL3";

  makeFlags = [
    "USE_INTERNAL_LIBS=0"
    "COPYDIR=$(out)/lib/realrtcw"
  ];

  installTargets = [ "copyfiles" ];

  preInstall = ''
    mkdir -p "$out/lib/realrtcw" "$out/bin"
  '';

  postInstall = ''
    bins=("$out/lib/realrtcw/RealRTCW."*)
    if [[ ''${#bins[@]} -eq 0 ]]; then
      echo "fatal: no executables found" >&2
      exit 1
    fi
    if [[ ''${#bins[@]} -gt 1 ]]; then
      echo "fatal: multiple executables found: ''${bins[*]}" >&2
      exit 1
    fi
    makeWrapper "''${bins[0]}" "$out/bin/realrtcw" --argv0 "''${bins[0]}"

    install -Dm644 misc/iortcw.svg "$out/share/icons/hicolor/scalable/apps/realrtcw.svg"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "realrtcw";
      exec = "realrtcw";
      icon = "realrtcw";
      desktopName = "RealRTCW";
      comment = finalAttrs.meta.description;
      categories = [ "Game" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "RealRTCW mod based on ioRTCW engine";
    homepage = "https://github.com/wolfetplayer/RealRTCW";
    license = lib.licenses.gpl3Plus;
    mainProgram = "realrtcw";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.lukaswrz ];
  };
})
