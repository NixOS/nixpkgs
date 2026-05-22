{
  lib,
  python3Packages,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  wrapGAppsHook4,
  desktop-file-utils,
  libadwaita,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "plattenalbum";
  version = "2.5.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "SoongNoonien";
    repo = "plattenalbum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e4282zs9z+UpAtF4fuVWpUtiUqC/Id3/kpEQd3C6Z38=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [ libadwaita ];

  dependencies = with python3Packages; [
    pygobject3
    mpd2
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(''${gappsWrapperArgs[@]})
  '';

  meta = {
    description = "Client for the Music Player Daemon (originally named mpdevil)";
    homepage = "https://github.com/SoongNoonien/plattenalbum";
    changelog = "https://github.com/SoongNoonien/plattenalbum/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      gpl3Only
      cc0
    ];
    mainProgram = "plattenalbum";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
})
