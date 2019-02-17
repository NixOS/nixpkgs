{ stdenv, fetchurl, file, which, intltool, gobject-introspection,
  findutils, xdg_utils, gnome3, pythonPackages, hicolor-icon-theme,
  wrapGAppsHook
}:

pythonPackages.buildPythonApplication rec {
  majorver = "1.4";
  minorver = "7";
  version = "${majorver}.${minorver}";
  pname = "catfish";

  src = fetchurl {
    url = "https://archive.xfce.org/src/apps/${pname}/${majorver}/${pname}-${version}.tar.bz2";
    sha256 = "1s97jb1r07ff40jnz8zianpn1f0c67hssn8ywdi2g7njfb4amjj8";
  };

  nativeBuildInputs = [
    pythonPackages.distutils_extra
    file
    which
    intltool
    gobject-introspection
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
    homepage = https://docs.xfce.org/apps/catfish/start;
    description = "A handy file search tool";
    longDescription = ''
      Catfish is a handy file searching tool. The interface is
      intentionally lightweight and simple, using only GTK+3.
      You can configure it to your needs by using several command line
      options.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
