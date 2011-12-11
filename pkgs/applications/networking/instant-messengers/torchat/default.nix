{ stdenv, fetchurl, python, unzip, wxPython, wrapPython, tor }:
stdenv.mkDerivation rec {

  name = "torchat-${version}";
  version = "0.9.9.550";

  src = fetchurl {
    url = "http://torchat.googlecode.com/files/torchat-source-${version}.zip";
    sha256 = "01z0vrmflcmb146m04b66zihkd22aqnxz2vr4x23z1q5mlwylmq2";
  };

  buildInputs = [ python unzip wxPython wrapPython ];
  pythonPath = [ wxPython ];

  preConfigure = "rm portable.txt";
  preUnpack = "sourceRoot=`pwd`/src";

  installPhase = ''
    substituteInPlace "Tor/tor.sh" --replace "tor -f" "${tor}/bin/tor -f"

    wrapPythonPrograms

    ensureDir $out/lib/torchat
    cp -rf * $out/lib/torchat
    makeWrapper ${python}/bin/python $out/bin/torchat \
        --set PYTHONPATH $out/lib/torchat:$program_PYTHONPATH \
        --run "cd $out/lib/torchat" \
        --add-flags "-O $out/lib/torchat/torchat.py"
  '';

  meta = with stdenv.lib; {
    homepage = http://code.google.com/p/torchat/;
    description = "instant messaging application on top of the Tor network and it's location hidden services";
    license = licenses.gpl3;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.unix;
  };
}
