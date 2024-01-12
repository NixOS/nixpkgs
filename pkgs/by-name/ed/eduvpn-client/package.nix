{ lib
, fetchurl
, gdk-pixbuf
, gobject-introspection
, gtk3
, libnotify
, libsecret
, networkmanager
, python3Packages
, wrapGAppsHook
}:

python3Packages.buildPythonApplication rec {
  pname = "eduvpn-client";
  version = "4.2.0";

  src = fetchurl {
    url = "https://github.com/eduvpn/python-${pname}/releases/download/${version}/python-${pname}-${version}.tar.xz";
    hash = "sha256-W5z0ykrwWANZmW+lQt6m+BmYPI0cutsamx8V2JrpeHA=";
  };

  nativeBuildInputs = [
    gdk-pixbuf
    gobject-introspection
    wrapGAppsHook
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
