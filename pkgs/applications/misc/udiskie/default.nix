{ stdenv, fetchFromGitHub, asciidoc-full, gettext
, gobjectIntrospection, gtk3, hicolor_icon_theme, libnotify
, pythonPackages, udisks2, wrapGAppsHook }:

pythonPackages.buildPythonApplication rec {
  name = "udiskie-${version}";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "coldfix";
    repo = "udiskie";
    rev = version;
    sha256 = "01x5fvllb262x6r3547l23z7p6hr7ddz034bkhmj2cqmf83sxwxd";
  };

  buildInputs = [
    asciidoc-full        # For building man page.
    hicolor_icon_theme
    wrapGAppsHook
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
