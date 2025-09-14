{
  lib,
  python3,
  fetchFromGitLab,
  desktop-file-utils,
  gobject-introspection,
  gtk3,
  libhandy,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "powersupply";
  version = "0.9.0";

  format = "other";

  src = fetchFromGitLab {
    owner = "martijnbraam";
    repo = "powersupply";
    rev = version;
    hash = "sha256-3NXoOqveMlMezYe4C78F3764KeAy5Sz3M714PO3h/eI=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gtk3
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libhandy
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  strictDeps = true;

  meta = {
    description = "Graphical app to display power status of mobile Linux platforms";
    homepage = "https://gitlab.com/MartijnBraam/powersupply";
    license = lib.licenses.mit;
    mainProgram = "powersupply";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
