{
  lib,
  python3Packages,
  fetchFromGitHub,
  meson,
  ninja,
  appstream,
  desktop-file-utils,
  gobject-introspection,
  wrapGAppsHook4,
  blueprint-compiler,
  pkg-config,
  libadwaita,
  libportal-gtk4,
  gnome,
  librsvg,
  libavif,
}:
python3Packages.buildPythonApplication rec {
  pname = "gradia";
  version = "1.5.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "AlexanderVanhee";
    repo = "Gradia";
    tag = "v${version}";
    hash = "sha256-IamiF3mn3rVmDJrEOl0Ji+7muo8e8kunOxAZJTBNjM8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    appstream
    desktop-file-utils
    gobject-introspection
    wrapGAppsHook4
    blueprint-compiler
    pkg-config
  ];

  buildInputs = [
    libadwaita
    libportal-gtk4
  ];

  dependencies = with python3Packages; [
    pygobject3
    pillow
  ];

  postInstall = ''
    export GDK_PIXBUF_MODULE_FILE="${
      gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
        extraLoaders = [
          librsvg
          libavif
        ];
      }
    }"
  '';

  dontWrapGApps = true;

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  meta = {
    description = "Make your screenshots ready for the world";
    homepage = "https://github.com/AlexanderVanhee/Gradia";
    changelog = "https://github.com/AlexanderVanhee/Gradia/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      Cameo007
      quadradical
    ];
    mainProgram = "gradia";
    platforms = lib.platforms.linux;
  };
}
