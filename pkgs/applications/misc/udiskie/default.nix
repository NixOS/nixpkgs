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
  version = "1.7.7";

  src = fetchFromGitHub {
    owner = "coldfix";
    repo = "udiskie";
    rev = version;
    sha256 = "1j17z26vy44il2s9zgchvhq280vq8ag64ddi35f35b444wz2azlb";
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
