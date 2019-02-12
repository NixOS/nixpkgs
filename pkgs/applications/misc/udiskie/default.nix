{ stdenv, fetchFromGitHub, asciidoc-full, gettext
, gobject-introspection, gtk3, hicolor-icon-theme, libappindicator-gtk3, libnotify, librsvg
, udisks2, wrapGAppsHook
, buildPythonApplication
, docopt
, pygobject3
, pyyaml
}:

buildPythonApplication rec {
  name = "udiskie-${version}";
  version = "1.7.5";

  src = fetchFromGitHub {
    owner = "coldfix";
    repo = "udiskie";
    rev = version;
    sha256 = "1mcdn8ha5d5nsmrzk6xnnsqrmk94rdrzym9sqm38zk5r8gpyl1k4";
  };

  buildInputs = [
    asciidoc-full        # For building man page.
    hicolor-icon-theme
    wrapGAppsHook
    librsvg              # required for loading svg icons (udiskie uses svg icons)
  ];

  propagatedBuildInputs = [
    gettext gobject-introspection gtk3 libnotify docopt
    pygobject3 pyyaml udisks2 libappindicator-gtk3
  ];

  postBuild = "make -C doc";

  postInstall = ''
    mkdir -p $out/share/man/man8
    cp -v doc/udiskie.8 $out/share/man/man8/
  '';

  # tests require dbusmock
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Removable disk automounter for udisks";
    license = licenses.mit;
    homepage = https://github.com/coldfix/udiskie;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
