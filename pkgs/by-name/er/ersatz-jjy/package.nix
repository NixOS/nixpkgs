{
  alsa-lib,
  cmake,
  fetchFromGitHub,
  lib,
  libjack2,
  pkg-config,
  portaudio,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "ersatz-jjy";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "ddelabru";
    repo = "ersatz-jjy";
    tag = "v${version}";
    hash = "sha256-Yb5o9tqAiLcU6bgXG/WBD5DHUj8yi9Wi1kfCZ6GEIdM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libjack2
    portaudio
  ] ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform alsa-lib) [ alsa-lib ];

  meta = {
    description = "JJY time code simulator";
    license = lib.licenses.gpl3Plus;
    homepage = "https://github.com/ddelabru/ersatz-jjy";
    maintainers = with lib.maintainers; [ ddelabru ];
    mainProgram = "ersatz-jjy";
    platforms = lib.platforms.unix;
  };
}
