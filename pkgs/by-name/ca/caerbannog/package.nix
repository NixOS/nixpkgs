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

python3.pkgs.buildPythonApplication rec {
  pname = "caerbannog";
  version = "0.3";
  format = "other";

  src = fetchFromSourcehut {
    owner = "~craftyguy";
    repo = "caerbannog";
    tag = version;
    sha256 = "0wqkb9zcllxm3fdsr5lphknkzy8r1cr80f84q200hbi99qql1dxh";
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
    gpgme
    pygobject3
  ];

  meta = {
    description = "Mobile-friendly Gtk frontend for password-store";
    mainProgram = "caerbannog";
    homepage = "https://sr.ht/~craftyguy/caerbannog/";
    changelog = "https://git.sr.ht/~craftyguy/caerbannog/refs/${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
