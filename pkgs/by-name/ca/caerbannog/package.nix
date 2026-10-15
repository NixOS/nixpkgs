{
  lib,
  fetchFromSourcehut,
  python3,
  glib,
  gobject-introspection,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
  atk,
  libhandy,
  libnotify,
  pango,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "caerbannog";
  version = "0.3";
  pyproject = false;

  src = fetchFromSourcehut {
    owner = "~craftyguy";
    repo = "caerbannog";
    tag = finalAttrs.version;
    hash = "sha256-sLdAMU4pLgiAwAQ5gDILGfk/7YSXlqybG7VTyn5aE3M=";
  };

  nativeBuildInputs = [
    glib
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    atk
    libhandy
    libnotify
    pango
  ];

  propagatedBuildInputs = with python3.pkgs; [
    anytree
    fuzzyfinder
    gpg
    pygobject3
  ];

  meta = {
    description = "Mobile-friendly Gtk frontend for password-store";
    mainProgram = "caerbannog";
    homepage = "https://sr.ht/~craftyguy/caerbannog/";
    changelog = "https://git.sr.ht/~craftyguy/caerbannog/refs/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
