{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "ryonakano";
    repo = "reco";
    rev = finalAttrs.version;
    hash = "sha256-o3I0gJYS4OrxMuOgX2Nyew6Zo0zTm35BiS6qb7/dr+s=";
  };

  patches = [
    # feat: Add support for livechart-2
    # https://github.com/ryonakano/reco/issues/351
    (fetchpatch {
      url = "https://github.com/ryonakano/reco/commit/d2dbbc6bd1533f4756ed0f2f0bf051d3f1360e4b.patch";
      hash = "sha256-B/maiftFouE92ux1qb6h7QDQ8EBNHmJPLukhZOztQ4I=";
    })
  ];

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
