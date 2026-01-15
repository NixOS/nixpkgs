{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libjack2,
  alsa-lib,
  libpulseaudio,
  faac,
  lame,
  libogg,
  libopus,
  libvorbis,
  libsamplerate,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "darkice";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "rafael2k";
    repo = "darkice";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-THsw7N80hkcKQmU3spUhTEuCHbGw+pkh3MPp5Isnk7c=";
  };
  sourceRoot = "source/darkice/trunk";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libopus
    libvorbis
    libogg
    libpulseaudio
    alsa-lib
    libsamplerate
    libjack2
    lame
  ];

  configureFlags = [
    "--with-faac-prefix=${faac}"
    "--with-lame-prefix=${lame.lib}"
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://darkice.org/";
    description = "Live audio streamer";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ikervagyok ];
  };
})
