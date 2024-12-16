{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
  libjack2,
  lilv,
  lv2,
  meson,
  ninja,
  pkg-config,
  portaudio,
  serd,
  sord,
  sratom,
  suil,
  wrapGAppsHook3,
  useJack ? true,
  useQt ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jalv";
  version = "1.6.8";

  src = fetchFromGitHub {
    owner = "drobilla";
    repo = "jalv";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-MAQoc+WcuoG6Psa44VRaZ2TWB2LBpvf6EmqbUZPUf38=";
  };

  nativeBuildInputs =
    [
      meson
      ninja
      pkg-config
    ]
    ++ lib.optionals (!useQt) [ wrapGAppsHook3 ]
    ++ lib.optionals useQt [ libsForQt5.wrapQtAppsHook ];

  buildInputs =
    [
      lilv
      lv2
      portaudio
      serd
      sord
      sratom
      suil
    ]
    ++ lib.optionals (!useJack) [ portaudio ]
    ++ lib.optionals useJack [ libjack2 ]
    ++ lib.optionals useQt [ libsForQt5.qtbase ];

  mesonFlags = [
    (lib.mesonEnable "portaudio" (!useJack))
    (lib.mesonEnable "jack" useJack)
    (lib.mesonEnable "gtk2" false)
    (lib.mesonEnable "gtk3" (!useQt))
    (lib.mesonEnable "qt5" useQt)
  ];

  meta = {
    description = "Simple but fully featured LV2 host for Jack";
    homepage = "http://drobilla.net/software/jalv";
    license = lib.licenses.isc;
    mainProgram = if useQt then "jalv.qt5" else "jalv.gtk3";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
