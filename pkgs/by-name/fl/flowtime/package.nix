{
  stdenv,
  lib,
  fetchFromGitHub,
  vala,
  meson,
  ninja,
  wrapGAppsHook4,
  gst_all_1,
  libadwaita,
  libxml2,
  desktop-file-utils,
  pkg-config,
  libportal-gtk4,
  blueprint-compiler,
  appstream-glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flowtime";
  version = "6.5";

  src = fetchFromGitHub {
    owner = "Diego-Ivan";
    repo = "Flowtime";
    rev = "v${finalAttrs.version}";
    hash = "sha256-J0Pscv0ZOpA/LV2mPTLOmDPQpfZhizTghatGnrJHToE=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
    appstream-glib
  ];

  buildInputs = [
    libadwaita
    libxml2
    libportal-gtk4
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
  ]);

  meta = {
    description = "Get what motivates you done, without losing concentration";
    mainProgram = "flowtime";
    homepage = "https://github.com/Diego-Ivan/Flowtime";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      pokon548
    ];
    platforms = lib.platforms.linux;
  };
})
