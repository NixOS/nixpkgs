{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  makeWrapper,
  gtk3,
  libcddb,
  intltool,
  pkg-config,
  cdparanoia,
  mp3Support ? false,
  lame,
  oggSupport ? true,
  vorbis-tools,
  flacSupport ? true,
  flac,
  opusSupport ? false,
  opus-tools,
  wavpackSupport ? false,
  wavpack,
  #, musepackSupport ? false, TODO: mpcenc
  monkeysAudioSupport ? false,
  monkeys-audio,
  #, aacSupport ? false, TODO: neroAacEnc
}:

let
  runtimeDeps =
    lib.optional mp3Support lame
    ++ lib.optional oggSupport vorbis-tools
    ++ lib.optional flacSupport flac
    ++ lib.optional opusSupport opus-tools
    ++ lib.optional wavpackSupport wavpack
    ++ lib.optional monkeysAudioSupport monkeys-audio
    ++ [ cdparanoia ];
in

stdenv.mkDerivation (finalAttrs: {
  pname = "asunder";
  version = "3.1.0-unstable-2025-03-24";

  src = fetchFromGitHub {
    owner = "rizalmart";
    repo = "asunder-gtk3";
    rev = "e3676704f7c7912e61ad7d78fe19015c102a27e1";
    hash = "sha256-bJVrSbjOUkmrF76e6euM5VPwbvvRrA5ZLPzZGjEep98=";
  };

  nativeBuildInputs = [
    autoreconfHook
    intltool
    makeWrapper
    pkg-config
  ];
  buildInputs = [
    gtk3
    libcddb
  ];

  postInstall = ''
    wrapProgram "$out/bin/asunder" \
      --prefix PATH : "${lib.makeBinPath runtimeDeps}"
  '';

  meta = {
    description = "Graphical Audio CD ripper and encoder for Linux";
    mainProgram = "asunder";
    homepage = "https://github.com/rizalmart/asunder-gtk3";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ mudri ];
    platforms = lib.platforms.linux;

    longDescription = ''
      Asunder is a graphical Audio CD ripper and encoder for Linux. You can use
      it to save tracks from an Audio CD as any of WAV, MP3, OGG, FLAC, Opus,
      WavPack, Musepack, AAC, and Monkey's Audio files.
    '';
  };
})
