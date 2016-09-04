{stdenv, fetchurl, pythonPackages}:

let
  inherit (pythonPackages) python;
in stdenv.mkDerivation rec {
  url = "ftp://ftp.goffi.org/sat/sat-0.2.0.tar.bz2";
  name = stdenv.lib.nameFromURL url ".tar";
  src = fetchurl {
    inherit url;
    sha256 = "14qqgsgqns1xcp97nd3jcxrq54z1x5a6kimqxy029hh7ys813mf1";
  };

  buildInputs = with pythonPackages; 
    [
      python twisted urwid beautifulsoup wxPython pygobject
      wokkel dbus-python pyfeed wrapPython setuptools
    ];

  configurePhase = ''
    sed -i "/use_setuptools/d" setup.py
    sed -e "s@sys.prefix@'$out'@g" -i setup.py
    sed -e "1aexport PATH=\"\$PATH\":\"$out/bin\":\"${pythonPackages.twisted}/bin\"" -i src/sat.sh
    sed -e "1aexport PYTHONPATH=\"\$PYTHONPATHPATH\":\"$PYTHONPATH\":"$out/${python.sitePackages}"" -i src/sat.sh

    echo 'import wokkel.muc' | python 
  '';

  buildPhase = ''
    ${python.interpreter} setup.py build
  '';

  installPhase = ''
    ${python.interpreter} setup.py install --prefix="$out"

    for i in "$out/bin"/*; do
      head -n 1 "$i" | grep -E '[/ ]python( |$)' && {
        wrapProgram "$i" --prefix PYTHONPATH : "$PYTHONPATH:$out/${python.sitePackages}"
      } || true 
    done
  '';
  
  meta = {
    homepage = "http://sat.goffi.org/";
    description = "A multi-frontend XMPP client";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [raskin];
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
