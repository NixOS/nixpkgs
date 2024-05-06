{ lib
, fetchurl
, gdk-pixbuf
, gobject-introspection
, gtk3
, libnotify
, libsecret
, networkmanager
, python3Packages
, wrapGAppsHook3
}:

python3Packages.buildPythonApplication rec {
  pname = "eduvpn-client";
  version = "4.2.1";

  src = fetchurl {
    url = "https://github.com/eduvpn/python-${pname}/releases/download/${version}/python-${pname}-${version}.tar.xz";
    hash = "sha256-57EKWOzGfA4ihVYTyfLF2yoe7hN/7OnEkG+zLz7QtxI=";
  };

  nativeBuildInputs = [
    gdk-pixbuf
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libnotify
    libsecret
    networkmanager
  ];

  propagatedBuildInputs = with python3Packages; [
    eduvpn-common
    pygobject3
    setuptools
  ];

  patches = [ ./nix-python-prefix.patch ];

  postPatch = ''
    substituteInPlace eduvpn/utils.py --subst-var-by out $out
  '';

  checkInputs = with python3Packages; [
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://raw.githubusercontent.com/eduvpn/python-eduvpn-client/${version}/CHANGES.md";
    description = "Linux client for eduVPN";
    homepage = "https://github.com/eduvpn/python-eduvpn-client";
    license = licenses.gpl3Plus;
    mainProgram = "eduvpn-gui";
    maintainers = with maintainers; [ benneti jwijenbergh ];
    platforms = platforms.linux;
  };
}
