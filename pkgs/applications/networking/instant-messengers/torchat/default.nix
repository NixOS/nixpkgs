{ lib, stdenv, fetchFromGitHub, python2, unzip, tor }:

stdenv.mkDerivation rec {
  pname = "torchat";
  version = "0.9.9.553";

  src = fetchFromGitHub {
    owner = "prof7bit";
    repo = "TorChat";
    rev = version;
    sha256 = "2LHG9qxZDo5rV6wsputdRo2Y1aHs+irMwt1ucFnXQE0=";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = with python2.pkgs; [ python wxPython wrapPython ];
  pythonPath = with python2.pkgs; [ wxPython ];

  preConfigure = "cd torchat/src; rm portable.txt";

  installPhase = ''
    substituteInPlace "Tor/tor.sh" --replace "tor -f" "${tor}/bin/tor -f"

    wrapPythonPrograms

    mkdir -p $out/lib/torchat
    cp -rf * $out/lib/torchat
    makeWrapper ${python2}/bin/python $out/bin/torchat \
        --set PYTHONPATH $out/lib/torchat:$program_PYTHONPATH \
        --run "cd $out/lib/torchat" \
        --add-flags "-O $out/lib/torchat/torchat.py"
  '';

  meta = with lib; {
    homepage = "https://github.com/prof7bit/TorChat";
    description = "Instant messaging application on top of the Tor network and it's location hidden services";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
