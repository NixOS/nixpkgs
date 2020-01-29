{ stdenv, fetchFromGitHub, asciidoc-full, gettext
, gobject-introspection, gtk3, libappindicator-gtk3, libnotify, librsvg
, udisks2, wrapGAppsHook
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "udiskie";
  version = "1.7.7";

  src = fetchFromGitHub {
    owner = "coldfix";
    repo = "udiskie";
    rev = version;
    sha256 = "1j17z26vy44il2s9zgchvhq280vq8ag64ddi35f35b444wz2azlb";
  };

  nativeBuildInputs = [
    gettext
    asciidoc-full        # For building man page.
    gobject-introspection
    wrapGAppsHook
  ];

  buildInputs = [
    librsvg              # required for loading svg icons (udiskie uses svg icons)
    gobject-introspection
    libnotify
    gtk3
    udisks2
    libappindicator-gtk3
  ];

  propagatedBuildInputs = with python3Packages; [
    docopt
    pygobject3
    pyyaml
  ];

  postBuild = "make -C doc";

  postInstall = ''
    mkdir -p $out/share/man/man8
    cp -v doc/udiskie.8 $out/share/man/man8/
  '';

  checkInputs = with python3Packages; [
    nose
    keyutils
  ];

  checkPhase = ''
    nosetests
  '';

  meta = with stdenv.lib; {
    description = "Removable disk automounter for udisks";
    license = licenses.mit;
    homepage = https://github.com/coldfix/udiskie;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
