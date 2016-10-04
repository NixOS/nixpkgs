{ stdenv, fetchurl, file, which, intltool, findutils, xdg_utils,
  gnome3, pythonPackages, wrapGAppsHook }:

pythonPackages.buildPythonApplication rec {
  majorver = "1.4";
  minorver = "2";
  version = "${majorver}.${minorver}";
  name = "catfish-${version}";

  src = fetchurl {
    url = "https://launchpad.net/catfish-search/${majorver}/${version}/+download/${name}.tar.bz2";
    sha256 = "0j3by9yfs4j9za3s5qdxrsm7idmps69pimc9d0mjyakvviy0izm3";
  };

  nativeBuildInputs = [
    pythonPackages.distutils_extra
    file
    which
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    gnome3.gtk
    gnome3.dconf
    pythonPackages.pyxdg
    pythonPackages.ptyprocess
    pythonPackages.pycairo
  ];

  propagatedBuildInputs = [
    pythonPackages.pygobject3
    pythonPackages.pexpect
    xdg_utils
    findutils
  ];

  preFixup = ''
    rm "$out/${pythonPackages.python.sitePackages}/catfish_lib/catfishconfig.pyc"
    for f in \
      "$out/${pythonPackages.python.sitePackages}/catfish_lib/catfishconfig.py" \
      "$out/share/applications/catfish.desktop"
    do
      substituteInPlace $f --replace "${pythonPackages.python}" "$out"
    done
  '';

  meta = with stdenv.lib; {
    description = "A handy file search tool";
    longDescription = ''
      Catfish is a handy file searching tool. The interface is
      intentionally lightweight and simple, using only GTK+3.
      You can configure it to your needs by using several command line
      options.
    '';
    homepage = https://launchpad.net/catfish-search;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
