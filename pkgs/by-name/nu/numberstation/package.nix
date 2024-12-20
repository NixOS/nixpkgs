{
  lib,
  python3,
  fetchFromSourcehut,
  desktop-file-utils,
  glib,
  gobject-introspection,
  gtk3,
  libhandy,
  librsvg,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "numberstation";
  version = "1.4.0";

  format = "other";

  src = fetchFromSourcehut {
    owner = "~martijnbraam";
    repo = "numberstation";
    rev = version;
    hash = "sha256-0T/Dc2i6auuZiWjcPR72JT8yOrzmdEmbW2PS5YhmEwI=";
  };

  postPatch = ''
    patchShebangs build-aux/meson
  '';

  nativeBuildInputs = [
    desktop-file-utils
    glib
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
    librsvg
  ];

  propagatedBuildInputs = with python3.pkgs; [
    keyring
    pygobject3
    pyotp
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    changelog = "https://git.sr.ht/~martijnbraam/numberstation/refs/${version}";
    description = "TOTP Authentication application for mobile";
    mainProgram = "numberstation";
    homepage = "https://sr.ht/~martijnbraam/numberstation/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
