{
  stdenv,
  fetchurl,
  fetchpatch,
  lib,
  pkg-config,
  alsa-lib,
  ffmpeg,
  libjack2,
  libogg,
  libpulseaudio,
  speexdsp,
  directoryListingUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "alsa-plugins";
  version = "1.2.12";

  src = fetchurl {
    url = "mirror://alsa/plugins/alsa-plugins-${finalAttrs.version}.tar.bz2";
    hash = "sha256-e9ioPTBOji2GoliV2Nyw7wJFqN8y4nGVnNvcavObZvI=";
  };

  patches = [
    (fetchpatch {
      name = "ffmpeg-9-compatibility.patch";
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/alsa-plugins/-/raw/7f250af93b76e9b3d552af509beb8ea1356114d1/ffmpeg9.patch";
      hash = "sha256-heAl6Ym3iYI8mhuuQpwBpc0FeFYsQZRHx4UUvqiVtBo=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    alsa-lib
    ffmpeg
    libjack2
    libogg
    libpulseaudio
    speexdsp
  ];

  passthru.updateScript = directoryListingUpdater {
    url = "https://alsa-project.org/files/pub/plugins/";
  };

  meta = {
    description = "Various plugins for ALSA";
    homepage = "https://alsa-project.org/";

    license = with lib.licenses; [
      lgpl21Plus
      lgpl2Plus # maemo plugin
      gpl2Plus # attributes.m4 & usb_stream.h
    ];

    maintainers = with lib.maintainers; [
      nick-linux
    ];
    platforms = lib.platforms.linux;
  };
})
