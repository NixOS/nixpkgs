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

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "numberstation";
  version = "1.4.0";

  pyproject = false;

  src = fetchFromSourcehut {
    owner = "~martijnbraam";
    repo = "numberstation";
    rev = finalAttrs.version;
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

  meta = {
    changelog = "https://git.sr.ht/~martijnbraam/numberstation/refs/${finalAttrs.version}";
    description = "TOTP Authentication application for mobile";
    mainProgram = "numberstation";
    homepage = "https://sr.ht/~martijnbraam/numberstation/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
