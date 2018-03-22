{ fetchFromGitHub, lib, python2Packages, meld, subversion, gvfs, xdg_utils }:
python2Packages.buildPythonApplication rec {
  name = "rabbitvcs-${version}";
  version = "0.17.1";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "rabbitvcs";
    repo = "rabbitvcs";
    rev = "v${version}";
    sha256 = "01cr16zf3gzsci1hhfli79m34fcx5m1pvswl16rkxxn212yc9fhy";
  };

  pythonPath = with python2Packages; [ configobj dbus-python pygobject2 pygtk simplejson pysvn dulwich tkinter gvfs xdg_utils ];

  prePatch = ''
      sed -ie 's|if sys\.argv\[1\] == "install":|if False:|' ./setup.py
      sed -ie "s|PREFIX = sys.prefix|PREFIX = \"$out\"|" ./setup.py
      sed -ie 's|/usr/bin/meld|${meld}/bin/meld|' ./rabbitvcs/util/configspec/configspec.ini
      sed -ie 's|/usr/bin/svnadmin|${subversion.out}/bin/svnadmin|' ./rabbitvcs/ui/create.py
      sed -ie "s|/usr/share/doc|$out/share/doc|" ./rabbitvcs/ui/about.py
      sed -ie "s|gnome-open|xdg-open|" ./rabbitvcs/util/helper.py
    '';

  outputs = [ "out" "cli" ];

  postInstall = ''
    mkdir -p $cli/bin
    cp clients/cli/rabbitvcs $cli/bin
    wrapPythonProgramsIn $cli "$out $pythonPath"
  '';

  doCheck = false;

  meta = {
    description = "Graphical tools for working with version control systems";
    homepage = http://rabbitvcs.org/;
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.mathnerd314 ];
  };
}
