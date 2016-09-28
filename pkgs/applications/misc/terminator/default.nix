{ stdenv, fetchurl, pythonPackages, keybinder, vte, gettext, intltool }:

pythonPackages.buildPythonApplication rec {
  name = "terminator-${version}";
  version = "0.98";
  
  src = fetchurl {
    url = "https://launchpad.net/terminator/trunk/${version}/+download/${name}.tar.gz";
    sha256 = "1h965z06dsfk38byyhnsrscd9r91qm92ggwgjrh7xminzsgqqv8a";
  };
  
  propagatedBuildInputs = with pythonPackages; [ pygtk notify keybinder vte gettext intltool ];

  #setupPyBuildFlags = [ "--without-icon-cache" ];

  doCheck = false;

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
    maintainers = [ maintainers.bjornfor ];
    platforms = platforms.linux;
  };
}
