{ stdenv, fetchFromGitHub, python2Packages }:

python2Packages.buildPythonApplication rec {
  pname = "zeronet";
  version = "0.6.2";
  format = "other";

  src = fetchFromGitHub {
    owner = "HelloZeroNet";
    repo = "ZeroNet";
    rev = "v${version}";
    sha256 = "0v19jjirkyv8hj2yfdj0c40zwynn51h2bj4issn5blr95vhfm8s7";
  };

  propagatedBuildInputs = with python2Packages; [ msgpack gevent ];
  buildPhase = "${python2Packages.python.interpreter} -O -m compileall .";

  installPhase = ''
    mkdir -p $out/share
    cp -r plugins src tools *.py $out/share/
  '';

  postFixup = ''
    makeWrapper "$out/share/zeronet.py" "$out/bin/zeronet" \
      --set PYTHONPATH "$PYTHONPATH" \
      --set PATH ${python2Packages.python}/bin
  '';

  meta = with stdenv.lib; {
    description = "Decentralized websites using Bitcoin crypto and BitTorrent network";
    homepage = "https://zeronet.io/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ fgaz ];
  };
}
