{ lib
, stdenv
, fetchFromGitHub
, nixosTests
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
, networkmanager
, networkmanagerapplet
, pkg-config
, python3
, wrapQtAppsHook
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
    pyqt5_sip
  ]);
in
stdenv.mkDerivation rec {
  pname = "firewalld";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "firewalld";
    repo = "firewalld";
    rev = "v${version}";
    sha256 = "sha256-UQ61do0f0bT3VNyZAx2ZuwQ+6SGvKUS6V5Y1B6EpJ5Q=";
  };

  patches = [
    ./respect-xml-catalog-files-var.patch
  ];

  postPatch = ''
    substituteInPlace src/firewall/config/__init__.py.in \
      --replace "/usr/share" "$out/share" \
      --replace "/usr/lib/" "$out/lib/"

    for file in config/firewall-{applet,config}.desktop.in; do
      substituteInPlace $file \
        --replace "/usr/bin/" "$out/bin/"
    done
  '' + lib.optionalString withGui ''
    substituteInPlace src/firewall-applet.in \
      --replace "/usr/bin/nm-connection-editor" "${networkmanagerapplet}/bin/nm-connection-editor"
  '';

  nativeBuildInputs = [
    autoreconfHook
    docbook_xml_dtd_42
    docbook-xsl-nons
    gobject-introspection
    glib
    intltool
    libxml2
    libxslt
    pkg-config
    python3
    python3.pkgs.wrapPython
    wrapGAppsNoGuiHook
  ] ++ lib.optionals withGui [
    wrapQtAppsHook
  ];

  buildInputs = [
    bash
    glib
    networkmanager
  ] ++ lib.optionals withGui [
    gtk3
    libnotify
    pythonPath
  ];

  dontWrapGApps = true;
  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '' + lib.optionalString withGui ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  postFixup = ''
    chmod +x $out/share/firewalld/*.py $out/share/firewalld/testsuite/python/*.py $out/share/firewalld/testsuite/{,integration/}testsuite
    patchShebangs --host $out/share/firewalld/testsuite/{,integration/}testsuite $out/share/firewalld/*.py
    wrapPythonProgramsIn "$out/bin" "$out ${pythonPath}"
    wrapPythonProgramsIn "$out/share/firewalld/testsuite/python" "$out ${pythonPath}"
  '';

  passthru.tests = nixosTests.firewalld;

  meta = with lib; {
    description = "Firewall daemon with D-Bus interface";
    homepage = "https://github.com/firewalld/firewalld";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
