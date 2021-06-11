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
  version = "0.4.0";

  format = "other";

  src = fetchFromSourcehut {
    owner = "~martijnbraam";
    repo = "numberstation";
    rev = version;
    sha256 = "038yyffqknr274f7jh5z12y68pjxr37f8y2cn2pwhf605jmbmpwv";
  };

  postPatch = ''
    patchShebangs build-aux/meson
  '';

  nativeBuildInputs = [
    desktop-file-utils
    glib
    gtk3
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gobject-introspection
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
