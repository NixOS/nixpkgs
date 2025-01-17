{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  cmake,
  appstream-glib,
  desktop-file-utils,
  wrapGAppsHook4,
  onnxruntime,
  libadwaita,
  libpulseaudio,
  xorg,
}:
let
  aprilAsr = fetchFromGitHub {
    name = "april-asr";
    owner = "abb128";
    repo = "april-asr";
    rev = "3308e68442664552de593957cad0fa443ea183dd";
    hash = "sha256-/cOZ2EcZu/Br9v0ComxnOegcEtlC9e8FYt3XHfah7mE=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "livecaptions";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "abb128";
    repo = "LiveCaptions";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bLWJQgZopuQ0t2pexazUTj1+C2weRMrL3PUhIHZ0W5M=";
  };

  model = fetchurl {
    name = "april-english-dev-01110_en.april";
    url = "https://april.sapples.net/april-english-dev-01110_en.april";
    hash = "sha256-d+uV0PpPdwijfoaMImUwHubELcsl5jymPuo9nLrbwfM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
    appstream-glib # appstreamcli
    desktop-file-utils # update-desktop-database
    wrapGAppsHook4
  ];

  buildInputs = [
    onnxruntime
    libadwaita
    libpulseaudio
    xorg.libX11
  ];

  postUnpack = ''
    rm -r source/subprojects/april-asr
    ln -s ${aprilAsr} source/subprojects/april-asr
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set APRIL_MODEL_PATH ${finalAttrs.model}
    )
  '';

  meta = with lib; {
    description = "Linux Desktop application that provides live captioning";
    homepage = "https://github.com/abb128/LiveCaptions";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Scrumplex ];
    mainProgram = "livecaptions";
  };
})
