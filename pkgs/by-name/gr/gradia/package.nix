{
  lib,
  python3Packages,
  fetchFromGitHub,
  meson,
  ninja,
  appstream,
  gtksourceview5,
  desktop-file-utils,
  gobject-introspection,
  wrapGAppsHook4,
  blueprint-compiler,
  pkg-config,
  libadwaita,
  libportal-gtk4,
  gnome,
  librsvg,
  webp-pixbuf-loader,
  libsoup_3,
  bash,
}:
python3Packages.buildPythonApplication rec {
  pname = "gradia";
  version = "1.7.1";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "AlexanderVanhee";
    repo = "Gradia";
    tag = "v${version}";
    hash = "sha256-EyO09tKv0SjqMyYM5J8wdeIH6/vJgF7p7FLaTfJDqXY=";
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
    gtksourceview5
    libadwaita
    libportal-gtk4
    libsoup_3
    bash
  ];

  dependencies = with python3Packages; [
    pygobject3
    pillow
  ];

  postInstall = ''
    substituteInPlace $out/share/gradia/gradia/ui/image_exporters.py --replace-fail "/bin/bash" "${lib.getExe bash}"
    export GDK_PIXBUF_MODULE_FILE="${
      gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
        extraLoaders = [
          librsvg
          webp-pixbuf-loader
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
