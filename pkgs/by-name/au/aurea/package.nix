{
  lib,
  python3Packages,
  fetchFromGitHub,
  meson,
  ninja,
  blueprint-compiler,
  desktop-file-utils,
  pkg-config,
  wrapGAppsHook4,
  libsoup_3,
  glib-networking,
  libadwaita,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "aurea";
  version = "1.7.0";
  pyproject = false; # uses meson

  src = fetchFromGitHub {
    owner = "CleoMenezesJr";
    repo = "Aurea";
    tag = finalAttrs.version;
    hash = "sha256-q+96G+bT3m3fOKHhOXTHFJ3ZlGXvrp89ga9Hg0c7Lcc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    blueprint-compiler
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
    libsoup_3
    glib-networking
  ];

  dependencies = with python3Packages; [
    pygobject3
    pillow
  ];

  strictDeps = true;

  dontWrapGApps = true;

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  postInstallCheck = ''
    mesonCheckPhase
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Flatpak metainfo banner previewer";
    homepage = "https://github.com/CleoMenezesJr/Aurea";
    mainProgram = "aurea";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
})
