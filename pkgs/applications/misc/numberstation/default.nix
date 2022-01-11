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
  version = "1.0.1";

  format = "other";

  src = fetchFromSourcehut {
    owner = "~martijnbraam";
    repo = "numberstation";
    rev = version;
    sha256 = "sha256-8q5cEpQRnevY98PKaTUW10bqRAr5NVG/rU24+nx27rw=";
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
    maintainers = with maintainers; [ dotlambda tomfitzhenry ];
  };
}
