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
  webp-pixbuf-loader,
  libsoup_3,
  bash,
}:
python3Packages.buildPythonApplication rec {
  pname = "gradia";
  version = "1.6.1";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "AlexanderVanhee";
    repo = "Gradia";
    tag = "v${version}";
    hash = "sha256-OfSqjxNfIk3dQZp4T6W1aL24FGEQKlFLGT+mV1+GR5o=";
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
