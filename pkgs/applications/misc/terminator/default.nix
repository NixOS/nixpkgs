{ stdenv, fetchurl, pythonPackages, pango, keybinder, vte, gettext, intltool, file
}:

pythonPackages.buildPythonApplication rec {
  name = "terminator-${version}";
  version = "1.0";

  src = fetchurl {
    url = "https://launchpad.net/terminator/trunk/${version}/+download/${name}.tar.gz";
    sha256 = "1pfspcxsbax8a835kcld32fax6vcxsn1fmkny9zzvi4icplhkal8";
  };

  nativeBuildInputs = [ file intltool ];

  pythonPath = with pythonPackages; [
    pygtk pygobject2 vte keybinder notify gettext pango psutil
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
