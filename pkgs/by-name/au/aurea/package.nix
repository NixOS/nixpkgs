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

python3Packages.buildPythonApplication rec {
  pname = "aurea";
  version = "1.6.1";
  pyproject = false; # uses meson

  src = fetchFromGitHub {
    owner = "CleoMenezesJr";
    repo = "Aurea";
    tag = version;
    hash = "sha256-XoLqtuh4ZIeKo8xb1ccaK+9K3uGuQfZt9Fb6NeUDCjE=";
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
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = [ ];
  };
}
