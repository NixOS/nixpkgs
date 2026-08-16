{
  lib,
  stdenv,
  fetchFromGitHub,
  blueprint-compiler,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  libadwaita,
  libgee,
  ryokucha,
  pantheon,
  gst_all_1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "reco";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "ryonakano";
    repo = "reco";
    rev = finalAttrs.version;
    hash = "sha256-Vy4T3iL1ADcegs69Oa6v5cCjaqYIy1SqzGPKdCwV2n8=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    libgee
    pantheon.live-chart
    ryokucha
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
