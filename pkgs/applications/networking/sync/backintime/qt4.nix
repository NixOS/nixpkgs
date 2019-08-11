{stdenv, makeWrapper, gettext, backintime-common, python3, python3Packages }:

stdenv.mkDerivation rec {
  inherit (backintime-common) version src installFlags;

  name = "backintime-qt4-${version}";

  buildInputs = [ makeWrapper gettext python3 python3Packages.pyqt4 backintime-common python3 ];

  preConfigure = "cd qt4";
  configureFlags = [  ];

  dontAddPrefix = true;

  preFixup =
      ''
      substituteInPlace "$out/bin/backintime-qt4" \
        --replace "=\"/usr/share" "=\"$prefix/share"

      wrapProgram "$out/bin/backintime-qt4" \
        --prefix PYTHONPATH : "${backintime-common}/share/backintime/common:$PYTHONPATH" \
        --prefix PATH : "${backintime-common}/bin:$PATH"
    '';

  meta = with stdenv.lib; {
    broken = true;
  };
}
