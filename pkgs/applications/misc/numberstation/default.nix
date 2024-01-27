{ lib
, python3
, fetchFromSourcehut
, desktop-file-utils
, glib
, gobject-introspection
, gtk3
, libhandy
, librsvg
, meson
, ninja
, pkg-config
, wrapGAppsHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "numberstation";
  version = "1.3.0";

  format = "other";

  src = fetchFromSourcehut {
    owner = "~martijnbraam";
    repo = "numberstation";
    rev = version;
    hash = "sha256-l4ev47ofBZeUqjJjdhQOHX+mNL9nIHH0mfYdqZW1LMs=";
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
    wrapGAppsHook
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
    description = "TOTP Authentication application for mobile";
    homepage = "https://sr.ht/~martijnbraam/numberstation/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
