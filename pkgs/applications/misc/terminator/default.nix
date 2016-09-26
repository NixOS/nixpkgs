{ stdenv, fetchurl, python2Packages, pango, keybinder, vte, gettext, intltool, file
}:

python2Packages.buildPythonApplication rec {
  name = "terminator-${version}";
  version = "0.98";

  src = fetchurl {
    url = "https://launchpad.net/terminator/trunk/${version}/+download/${name}.tar.gz";
    sha256 = "1h965z06dsfk38byyhnsrscd9r91qm92ggwgjrh7xminzsgqqv8a";
  };

  nativeBuildInputs = [ file intltool ];

  pythonPath = with python2Packages; [
    pygtk pygobject2 vte keybinder notify gettext pango
  ];

  postPatch = ''
    patchShebangs .
  '';

  checkPhase = ''
    ./run_tests
  '';

  meta = with stdenv.lib; {
    description = "Terminal emulator with support for tiling and tabs";
    longDescription = ''
      The goal of this project is to produce a useful tool for arranging
      terminals. It is inspired by programs such as gnome-multi-term,
      quadkonsole, etc. in that the main focus is arranging terminals in grids
      (tabs is the most common default method, which Terminator also supports).
    '';
    homepage = http://gnometerminator.blogspot.no/p/introduction.html;
    license = licenses.gpl2;
    maintainers = with maintainers; [ bjornfor globin ];
    platforms = platforms.linux;
  };
}
