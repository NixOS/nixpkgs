{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  vala,
  wrapGAppsHook4,
  desktop-file-utils,
  shared-mime-info,
  libarchive,
  libgee,
  pantheon,
  libxml2,
  libportal-gtk4,
  libwebp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "annotator";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "phase1geo";
    repo = "annotator";
    tag = finalAttrs.version;
    hash = "sha256-nJxms/df5OnASbdj4a2IjHyRT5PA2EaKHkBoQsyv8T8=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    vala
    wrapGAppsHook4
    desktop-file-utils
    shared-mime-info
  ];

  buildInputs = [
    libarchive
    libgee
    pantheon.granite7
    libportal-gtk4
    libxml2
    libwebp
  ];

  meta = {
    description = "Image annotation for Elementary OS";
    homepage = "https://github.com/phase1geo/Annotator";
    license = lib.licenses.gpl3Plus;
    mainProgram = "com.github.phase1geo.annotator";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
