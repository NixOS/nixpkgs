{stdenv, fetchurl, python27Packages, file }:

let
  inherit (python27Packages) python;
in
  stdenv.mkDerivation rec {
    name = "salut-a-toi";
    version = "0.6.1";
    pname = "sat-${version}";

    src = fetchurl {
      url = "ftp://ftp.goffi.org/sat/${pname}.tar.bz2";
      sha256 = "0kn9403n8fpzl0hsb9kkzicsmzq2fjl627l31yykbqzc4nsr780d";
    };

    buildInputs = with python27Packages; 
    [
      python twisted urwid beautifulsoup wxPython pygobject2
      wokkel dbus-python pyfeed wrapPython setuptools file 
      pycrypto pyxdg
    ];

    configurePhase = ''
      sed -i "/use_setuptools/d" setup.py
      sed -e "s@sys.prefix@'$out'@g" -i setup.py
      sed -e "1aexport PATH=\"\$PATH\":\"$out/bin\":\"${python27Packages.twisted}/bin\"" -i src/sat.sh
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

    meta = with stdenv.lib; {
      homepage = http://sat.goffi.org/;
      description = "A multi-frontend XMPP client";
      platforms = platforms.linux;
      maintainers = [ maintainers.raskin ];
      license = licenses.gpl3Plus;
    };
  }
