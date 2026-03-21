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
  glib-networking,
  tesseract,
  nix-update-script,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gradia";
  version = "1.12.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "AlexanderVanhee";
    repo = "Gradia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iYqMuqq2AmrdNMa7dkDUGg1+gCG7wL/rDEdWAPfcQnw=";
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
    glib-networking
    tesseract
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace "/app/bin/tesseract" "${lib.getExe tesseract}"
  '';

  dependencies = with python3Packages; [
    pygobject3
    pillow
    pytesseract
  ];

  postInstall = ''
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Make your screenshots ready for the world";
    homepage = "https://github.com/AlexanderVanhee/Gradia";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      Cameo007
      quadradical
      claymorwan
    ];
    mainProgram = "gradia";
    platforms = lib.platforms.linux;
  };
})
