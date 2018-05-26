{ stdenv, fetchFromGitHub, asciidoc-full, gettext
, gobjectIntrospection, gtk3, hicolor-icon-theme, libnotify, librsvg
, udisks2, wrapGAppsHook
, buildPythonApplication
, docopt
, pygobject3
, pyyaml
}:

buildPythonApplication rec {
  name = "udiskie-${version}";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "coldfix";
    repo = "udiskie";
    rev = version;
    sha256 = "0r3m8y6ppkl8p1lhr89sfk9v2la1zn0rbmr6hy860j7b22yvnkrn";
  };

  buildInputs = [
    asciidoc-full        # For building man page.
    hicolor-icon-theme
    wrapGAppsHook
    librsvg              # required for loading svg icons (udiskie uses svg icons)
  ];

  propagatedBuildInputs = [
    gettext gobjectIntrospection gtk3 libnotify docopt
    pygobject3 pyyaml udisks2
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
