{ stdenv, fetchFromGitHub, asciidoc-full, gettext
, gobjectIntrospection, gtk3, hicolor_icon_theme, libnotify, librsvg
, pythonPackages, udisks2, wrapGAppsHook }:

pythonPackages.buildPythonApplication rec {
  name = "udiskie-${version}";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "coldfix";
    repo = "udiskie";
    rev = version;
    sha256 = "1p732gi6lhwcqxvsa0pknb6jmhy3kgv3yzz7xzmdzhy47m312965";
  };

  buildInputs = [
    asciidoc-full        # For building man page.
    hicolor_icon_theme
    wrapGAppsHook
    librsvg              # required for loading svg icons (udiskie uses svg icons)
  ];

  propagatedBuildInputs = [
    gettext gobjectIntrospection gtk3 libnotify pythonPackages.docopt
    pythonPackages.pygobject3 pythonPackages.pyyaml udisks2
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
