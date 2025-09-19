{
  lib,
  fetchFromGitHub,
  wrapGAppsHook4,
  meson,
  ninja,
  pkg-config,
  glib,
  glib-networking,
  desktop-file-utils,
  gettext,
  librsvg,
  blueprint-compiler,
  python3Packages,
  sassc,
  appstream-glib,
  libadwaita,
  gtk4,
  libportal,
  libportal-gtk4,
  libsoup_3,
  polkit,
  gobject-introspection,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "nix-disk-manager";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "Gaming-Linux-FR";
    repo = "nix-disk-manager";
    tag = version;
    sha256 = "sha256-NLi1dnTrwixSO07DVucdrEZJZBRpNCT8TxlOGjxSKY0=";
  };

  format = "other";
  dontWrapGApps = true;

  nativeBuildInputs = [
    appstream-glib
    blueprint-compiler
    desktop-file-utils
    gettext
    glib
    gobject-introspection
    meson
    ninja
    wrapGAppsHook4
    pkg-config
  ];

  buildInputs = [
    libadwaita
    librsvg
    polkit.bin
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
  ];

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Disk manager for NixOS";
    homepage = "https://github.com/Gaming-Linux-FR/nix-disk-manager";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.linux;
    mainProgram = "nix-disk-manager";
  };
}
