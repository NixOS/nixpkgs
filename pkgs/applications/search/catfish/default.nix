{ stdenv, fetchurl, file, which, intltool, gobject-introspection,
  findutils, xdg_utils, gnome3, gtk3, pythonPackages, hicolor-icon-theme,
  wrapGAppsHook
}:

pythonPackages.buildPythonApplication rec {
  majorver = "1.4";
  minorver = "10";
  version = "${majorver}.${minorver}";
  pname = "catfish";

  src = fetchurl {
    url = "https://archive.xfce.org/src/apps/${pname}/${majorver}/${pname}-${version}.tar.bz2";
    sha256 = "0g9l5sv5d7wmyb23cvpz5mpvjnxiqjh25v9gr5qzhcah202a0wr5";
  };

  nativeBuildInputs = [
    pythonPackages.distutils_extra
    file
    which
    intltool
    gobject-introspection # for setup hook populating GI_TYPELIB_PATH
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    gnome3.dconf
    pythonPackages.pyxdg
    pythonPackages.ptyprocess
    pythonPackages.pycairo
    hicolor-icon-theme
    gobject-introspection # Temporary fix, see https://github.com/NixOS/nixpkgs/issues/56943
  ];

  propagatedBuildInputs = [
    pythonPackages.dbus-python
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
    description = "Handy file search tool";
    longDescription = ''
      Catfish is a handy file searching tool. The interface is
      intentionally lightweight and simple, using only GTK 3.
      You can configure it to your needs by using several command line
      options.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
