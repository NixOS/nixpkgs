{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, bash
, docbook_xml_dtd_42
, docbook-xsl-nons
, glib
, gobject-introspection
, gtk3
, intltool
, libnotify
, libxml2
, libxslt
, networkmanagerapplet
, pkg-config
, python3
, wrapGAppsNoGuiHook
, withGui ? false
}:

let
  pythonPath = python3.withPackages (ps: with ps; [
    dbus-python
    nftables
    pygobject3
  ] ++ lib.optionals withGui [
    pyqt5
    pyqt5-sip
  ]);
in
stdenv.mkDerivation rec {
  pname = "firewalld";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "firewalld";
    repo = "firewalld";
    rev = "v${version}";
    sha256 = "sha256-VI1LyedohInmZb7heNoZ/4cvLz5IImEE2tyNylvr2mU=";
  };

  patches = [
    ./respect-xml-catalog-files-var.patch
  ];

  postPatch = ''
    substituteInPlace src/firewall/config/__init__.py.in \
      --replace "/usr/share" "$out/share"

    for file in config/firewall-{applet,config}.desktop.in; do
      substituteInPlace $file \
        --replace "/usr/bin/" "$out/bin/"
    done
  '' + lib.optionalString withGui ''
    substituteInPlace src/firewall-applet.in \
      --replace "/usr/bin/nm-connection-editor" "${networkmanagerapplet}/bin/nm-conenction-editor"
  '';

  nativeBuildInputs = [
    autoreconfHook
    docbook_xml_dtd_42
    docbook-xsl-nons
    glib
    intltool
    libxml2
    libxslt
    pkg-config
    python3
    python3.pkgs.wrapPython
  ] ++ lib.optionals withGui [
    gobject-introspection
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    bash
    glib
  ] ++ lib.optionals withGui [
    gtk3
    libnotify
    pythonPath
  ];

  dontWrapGApps = true;

  preFixup = lib.optionalString withGui ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = ''
    chmod +x $out/share/firewalld/*.py $out/share/firewalld/testsuite/python/*.py $out/share/firewalld/testsuite/{,integration/}testsuite
    patchShebangs --host $out/share/firewalld/testsuite/{,integration/}testsuite $out/share/firewalld/*.py
    wrapPythonProgramsIn "$out/bin" "$out ${pythonPath}"
    wrapPythonProgramsIn "$out/share/firewalld/testsuite/python" "$out ${pythonPath}"
  '';

  meta = with lib; {
    description = "Firewall daemon with D-Bus interface";
    homepage = "https://github.com/firewalld/firewalld";
    license = licenses.gpl2Plus;
    maintainers = [ ];
  };
}
