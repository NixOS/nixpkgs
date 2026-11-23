{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  vala,
  desktop-file-utils,
  appstream,
  appstream-glib,
  blueprint-compiler,
  wrapGAppsHook4,
  libadwaita,
  libgee,
  gstreamer,
  gst-plugins-ugly,
  gst-plugins-rs,
  gst-plugins-good,
  gst-plugins-base,
  gst-plugins-bad,
  sqlite,
  xxhash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "daikhan";
  version = "0.1-alpha7";

  src = fetchFromGitLab {
    owner = "daikhan";
    repo = "daikhan";
    tag = finalAttrs.version;
    hash = "sha256-6Y2+4WUrbtzHin0UhTy6Iw4J7eY1glZU9CCv2mv10gI=";
  };

  postPatch = ''
    # gresource includes the generated metainfo file but doesn't depend on it, which races under low parallelism
    substituteInPlace src/meson.build \
      --replace-fail "dependencies: blueprints," "dependencies: [blueprints, metainfo_file],"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    desktop-file-utils
    appstream
    appstream-glib
    blueprint-compiler
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    libgee
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-plugins-rs
    sqlite
    xxhash
  ];

  mesonFlags = [
    (lib.mesonOption "profile" "stable")
  ];

  meta = {
    description = "Media player for the modern desktop";
    homepage = "https://gitlab.com/daikhan/daikhan";
    changelog = "https://gitlab.com/daikhan/daikhan/-/blob/${finalAttrs.version}/NEWS";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ samirbgno ];
    mainProgram = "daikhan";
    platforms = lib.platforms.linux;
  };
})
