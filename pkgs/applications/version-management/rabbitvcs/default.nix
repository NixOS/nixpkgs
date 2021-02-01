{ fetchFromGitHub, lib, python3Packages, meld, subversion, gvfs, xdg-utils, gtk3 }:

python3Packages.buildPythonApplication rec {
  pname = "rabbitvcs";
  version = "0.18";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "rabbitvcs";
    repo = "rabbitvcs";
    rev = "v${version}";
    sha256 = "01cr16zf3gzsci1hhfli79m34fcx5m1pvswl16rkxxn212yc9fhy";
  };

  buildInputs = [ gtk3 ];
  pythonPath = with python3Packages; [ configobj pygobject3 pysvn dulwich tkinter gvfs xdg-utils ];

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
    homepage = "http://rabbitvcs.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.mathnerd314 ];
  };
}
