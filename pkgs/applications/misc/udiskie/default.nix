{ stdenv, fetchFromGitHub, asciidoc-full, gettext
, gobjectIntrospection, gtk3, hicolor-icon-theme, libnotify, librsvg
, udisks2, wrapGAppsHook
, buildPythonApplication
, docopt
, pygobject3
, pyyaml
, ...
}:

buildPythonApplication rec {
  name = "udiskie-${version}";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "coldfix";
    repo = "udiskie";
    rev = version;
    sha256 = "1yv1faq81n3vspf3jprcs5v21l2fchy3m3pc7lk8jb0xqlnh60x4";
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
