{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  obs-studio,
  curl,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-bilibili-stream";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "Zarosmm";
    repo = "obs-bilibili-stream";
    tag = finalAttrs.version;
    hash = "sha256-WcoAqlBq45y3M4krx5hFeuNCxI88GsP287RBHmzEp5E=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    obs-studio
    curl
    qt6.qtbase
  ];

  # https://github.com/Zarosmm/obs-bilibili-stream/blob/2.1.6/CMakePresets.json#L12-L15
  cmakeFlags = [
    (lib.cmakeBool "ENABLE_FRONTEND_API" true)
    (lib.cmakeBool "ENABLE_QT" true)
  ];

  # The plugin ships a Qt dialog but OBS resolves the Qt libraries itself, so
  # wrapping the plugin would be wrong.
  dontWrapQtApps = true;

  # Upstream's CMake installs the plugin twice: into lib/obs-plugins/ (the
  # layout the OBS wrapper reads, via OBS_PLUGINS_PATH) and into
  # obs-plugins/64bit/ (OBS's own default prefix). The second copy is unused
  # here and only adds weight and confusion, so drop it.
  postInstall = ''
    rm -rf "$out/obs-plugins"
  '';

  meta = {
    description = "Bilibili streaming plugin for OBS Studio";
    homepage = "https://github.com/Zarosmm/obs-bilibili-stream";
    changelog = "https://github.com/Zarosmm/obs-bilibili-stream/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    inherit (obs-studio.meta) platforms;
    maintainers = with lib.maintainers; [ kitsunori ];
  };
})
