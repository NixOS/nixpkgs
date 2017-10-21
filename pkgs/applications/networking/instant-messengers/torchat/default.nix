{ stdenv, fetchurl, python, unzip, wxPython, wrapPython, tor }:
stdenv.mkDerivation rec {

  name = "torchat-${version}";
  version = "0.9.9.553";

  src = fetchurl {
    url = "https://github.com/prof7bit/TorChat/archive/${version}.tar.gz";
    sha256 = "0rb4lvv40pz6ab5kxq40ycvh7kh1yxn7swzgv2ff2nbhi62xnzp0";
  };

  buildInputs = [ python unzip wxPython wrapPython ];
  pythonPath = [ wxPython ];

  preConfigure = "cd torchat/src; rm portable.txt";

  installPhase = ''
    substituteInPlace "Tor/tor.sh" --replace "tor -f" "${tor}/bin/tor -f"

    wrapPythonPrograms

    mkdir -p $out/lib/torchat
    cp -rf * $out/lib/torchat
    makeWrapper ${python}/bin/python $out/bin/torchat \
        --set PYTHONPATH $out/lib/torchat:$program_PYTHONPATH \
        --run "cd $out/lib/torchat" \
        --add-flags "-O $out/lib/torchat/torchat.py"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/prof7bit/TorChat;
    description = "Instant messaging application on top of the Tor network and it's location hidden services";
    license = licenses.gpl3;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.unix;
    broken = true;
  };
}
