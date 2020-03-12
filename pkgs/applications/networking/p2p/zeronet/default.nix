{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "zeronet";
  version = "0.7.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "HelloZeroNet";
    repo = "ZeroNet";
    rev = "v${version}";
    sha256 = "04prgicm0yjh2klcxdgwx1mvlsxxi2bdkzfcvysvixbgq20wjvdk";
  };

  propagatedBuildInputs = with python3Packages; [
    gevent msgpack base58 merkletools rsa pysocks pyasn1 websocket_client
    gevent-websocket rencode bitcoinlib maxminddb pyopenssl
  ];

  buildPhase = ''
    ${python3Packages.python.interpreter} -O -m compileall .
  '';

  installPhase = ''
    mkdir -p $out/share
    cp -r plugins src tools *.py $out/share/
  '';

  postFixup = ''
    makeWrapper "$out/share/zeronet.py" "$out/bin/zeronet" \
      --set PYTHONPATH "$PYTHONPATH" \
      --set PATH ${python3Packages.python}/bin
  '';

  meta = with stdenv.lib; {
    description = "Decentralized websites using Bitcoin crypto and BitTorrent network";
    homepage = "https://zeronet.io/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ fgaz ];
  };
}
