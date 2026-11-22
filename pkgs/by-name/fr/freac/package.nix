{
  lib,
  stdenv,
  fetchFromGitHub,

  boca,
  makeWrapper,
  faac,
  faad2,
  flac,
  lame,
  libopus,
  libvorbis,
  mpg123,
  smooth,
  systemd,
  wrapGAppsHook3,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freac";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "enzo1982";
    repo = "freac";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-bHoRxxhSM7ipRkiBG7hEa1Iw8Z3tOHQ/atngC/3X1a4=";
  };

  buildInputs = [
    boca
    smooth
    systemd
    wrapGAppsHook3
  ];

  makeFlags = [
    "prefix=$(out)"
  ];

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/freac \
    --prefix LD_LIBRARY_PATH : "${
      lib.makeLibraryPath [
        lame
        flac
        faac
        faad2
        libvorbis
        libopus
        mpg123
      ]
    }"
  '';

  meta = with lib; {
    description = "Audio converter and CD ripper with support for various popular formats and encoders";
    license = lib.licenses.gpl2Plus;
    homepage = "https://www.freac.org/";
    downloadPage = "https://www.freac.org/downloads-mainmenu-33";
    changelog = "https://github.com/enzo1982/freac/releases/tag/${finalAttrs.src.tag}";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ VZstless ];
    mainProgram = "freac";
  };
})
