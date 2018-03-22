{ stdenv, fetchurl, file, which, intltool, gobjectIntrospection,
  findutils, xdg_utils, gnome3, pythonPackages, hicolor-icon-theme,
  wrapGAppsHook
}:

pythonPackages.buildPythonApplication rec {
  majorver = "1.4";
  minorver = "4";
  version = "${majorver}.${minorver}";
  pname = "catfish";

  src = fetchurl {
    url = "https://launchpad.net/catfish-search/${majorver}/${version}/+download/${pname}-${version}.tar.gz";
    sha256 = "1mw7py6si6y88jblmzm04hf049bpww7h87k2wypq07zm1dw55m52";
  };

  nativeBuildInputs = [
    pythonPackages.distutils_extra
    file
    which
    intltool
    gobjectIntrospection
    wrapGAppsHook
  ];

  buildInputs = [
    gnome3.gtk
    gnome3.dconf
    pythonPackages.pyxdg
    pythonPackages.ptyprocess
    pythonPackages.pycairo
    hicolor-icon-theme
  ];

  propagatedBuildInputs = [
    pythonPackages.pygobject3
    pythonPackages.pexpect
    xdg_utils
    findutils
  ];

  # Explicitly set the prefix dir in "setup.py" because setuptools is
  # not using "$out" as the prefix when installing catfish data. In
  # particular the variable "__catfish_data_directory__" in
  # "catfishconfig.py" is being set to a subdirectory in the python
  # path in the store.
  postPatch = ''
    sed -i "/^        if self.root/i\\        self.prefix = \"$out\"" setup.py
  '';

  # Disable check because there is no test in the source distribution
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://launchpad.net/catfish-search;
    description = "A handy file search tool";
    longDescription = ''
      Catfish is a handy file searching tool. The interface is
      intentionally lightweight and simple, using only GTK+3.
      You can configure it to your needs by using several command line
      options.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
