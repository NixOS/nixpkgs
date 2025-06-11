{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  libgee,
  live-chart,
  ryokucha,
  pantheon,
  gst_all_1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "reco";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "ryonakano";
    repo = "reco";
    rev = finalAttrs.version;
    hash = "sha256-uZAcZJLQH0MTI4NSJnZvzYPBFVXGBqAhsjVLAVP/ZwI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    libgee
    live-chart
    ryokucha
    pantheon.granite7
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-libav
  ];

  mesonFlags = [ (lib.mesonBool "use_submodule" false) ];

  meta = {
    description = "Audio recorder focused on being concise and simple to use";
    homepage = "https://github.com/ryonakano/reco";
    license = lib.licenses.gpl3Plus;
    mainProgram = "com.github.ryonakano.reco";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})
