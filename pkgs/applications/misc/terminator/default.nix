{ stdenv, fetchurl, python, pygtk, notify, keybinder, vte, gettext, intltool
, makeWrapper
}:

stdenv.mkDerivation rec {
  name = "terminator-${version}";
  version = "0.98";
  
  src = fetchurl {
    url = "https://launchpad.net/terminator/trunk/${version}/+download/${name}.tar.gz";
    sha256 = "1h965z06dsfk38byyhnsrscd9r91qm92ggwgjrh7xminzsgqqv8a";
  };
  
  buildInputs = [
    python pygtk notify keybinder vte gettext intltool makeWrapper
  ];

  installPhase = ''
    python setup.py --without-icon-cache install --prefix="$out"

    for file in "$out"/bin/*; do
        wrapProgram "$file" \
            --prefix PYTHONPATH : "$(toPythonPath $out):$PYTHONPATH"
    done
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
    maintainers = [ maintainers.bjornfor ];
    platforms = platforms.linux;
  };
}
