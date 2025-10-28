{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  docbook_xml_dtd_42,
  docbook-xsl-nons,
  glib,
  gobject-introspection,
  gtk3,
  intltool,
  ipset,
  iptables,
  kdePackages,
  kmod,
  libnotify,
  librsvg,
  libxml2,
  libxslt,
  networkmanager,
  networkmanagerapplet,
  pkg-config,
  python3,
  qt6,
  sysctl,
  wrapGAppsNoGuiHook,
  withGui ? false,
}:

let
  pythonPath = python3.withPackages (
    ps:
    with ps;
    [
      dbus-python
      nftables
      pygobject3
    ]
    ++ lib.optionals withGui [
      pyqt6
    ]
  );
in
stdenv.mkDerivation rec {
  pname = "firewalld";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "firewalld";
    repo = "firewalld";
    rev = "v${version}";
    sha256 = "sha256-ONpyJJjIn5kEnkudZe4Nf67wdQgWa+2qEkT1nxRBDpI=";
  };

  patches = [
    ./add-config-path-env-var.patch
    ./respect-xml-catalog-files-var.patch
    ./specify-localedir.patch

    ./gettext-0.25.patch
  ];

  postPatch = ''
    substituteInPlace config/xmlschema/check.sh \
      --replace-fail /usr/bin/ ""

    for file in src/{firewall-offline-cmd.in,firewall/config/__init__.py.in} \
      config/firewall-{applet,config}.desktop.in; do
        substituteInPlace $file \
          --replace-fail /usr "$out"
    done
  ''
  + lib.optionalString withGui ''
    substituteInPlace src/firewall-applet.in \
      --replace-fail "/usr/bin/systemsettings" "${kdePackages.systemsettings}/bin/systemsettings" \
      --replace-fail "/usr/bin/nm-connection-editor" "${networkmanagerapplet}/bin/nm-connection-editor"
  '';

  nativeBuildInputs = [
    autoconf
    automake
    docbook_xml_dtd_42
    docbook-xsl-nons
    glib
    intltool
    libxml2
    libxslt
    pkg-config
    python3
    python3.pkgs.wrapPython
    wrapGAppsNoGuiHook
  ]
  ++ lib.optionals withGui [
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    glib
    gobject-introspection
    ipset
    iptables
    kmod
    networkmanager
    pythonPath
    sysctl
  ]
  ++ lib.optionals withGui [
    gtk3
    libnotify
    librsvg
    qt6.qtbase
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  ac_cv_path_MODPROBE = lib.getExe' kmod "modprobe";
  ac_cv_path_RMMOD = lib.getExe' kmod "rmmod";
  ac_cv_path_SYSCTL = lib.getExe' sysctl "sysctl";

  configureFlags = [
    "--with-iptables=${lib.getExe' iptables "iptables"}"
    "--with-iptables-restore=${lib.getExe' iptables "iptables-restore"}"
    "--with-ip6tables=${lib.getExe' iptables "ip6tables"}"
    "--with-ip6tables-restore=${lib.getExe' iptables "ip6tables-restore"}"
    "--with-ebtables=${lib.getExe' iptables "ebtables"}"
    "--with-ebtables-restore=${lib.getExe' iptables "ebtables-restore"}"
    "--with-ipset=${lib.getExe' ipset "ipset"}"
  ];

  postInstall = ''
    rm -r $out/share/firewalld/testsuite
  ''
  + lib.optionalString (!withGui) ''
    rm $out/bin/firewall-{applet,config}
  '';

  dontWrapGApps = true;
  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  ''
  + lib.optionalString withGui ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  postFixup = ''
    chmod +x $out/share/firewalld/*.py
    patchShebangs --host $out/share/firewalld/*.py
    wrapPythonProgramsIn "$out/bin" "$out ${pythonPath}"
  '';

  meta = {
    description = "Firewall daemon with D-Bus interface";
    homepage = "https://firewalld.org";
    downloadPage = "https://github.com/firewalld/firewalld/releases";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ prince213 ];
    platforms = lib.platforms.linux;
  };
}
