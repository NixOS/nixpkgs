{ stdenv, fetchurl, python2, keybinder3, intltool, file, gtk3, gobject-introspection
, libnotify, wrapGAppsHook, vte
}:

python2.pkgs.buildPythonApplication rec {
  name = "terminator-${version}";
  version = "1.91";

  src = fetchurl {
    url = "https://launchpad.net/terminator/gtk3/${version}/+download/${name}.tar.gz";
    sha256 = "95f76e3c0253956d19ceab2f8da709a496f1b9cf9b1c5b8d3cd0b6da3cc7be69";
  };

  nativeBuildInputs = [ file intltool wrapGAppsHook gobject-introspection ];
  buildInputs = [ gtk3 vte libnotify keybinder3 ];
  propagatedBuildInputs = with python2.pkgs; [ pygobject3 psutil pycairo ];

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
    homepage = https://gnometerminator.blogspot.no/p/introduction.html;
    license = licenses.gpl2;
    maintainers = with maintainers; [ bjornfor globin ];
    platforms = platforms.linux;
  };
}
