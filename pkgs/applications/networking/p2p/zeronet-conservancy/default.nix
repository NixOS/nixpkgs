{ lib
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "zeronet-conservancy";
  version = "0.7.5";
  format = "other";

  src = fetchFromGitHub {
    owner = "zeronet-conservancy";
    repo = "zeronet-conservancy";
    rev = "v${version}";
    sha256 = "sha256-cq0q5hXEhazHPJODNJ8iL0qAB5DJW6ANST4r/rslvXk=";
  };

  propagatedBuildInputs = with python3Packages; [
    gevent msgpack base58 merkletools rsa pysocks pyasn1 websocket-client
    gevent-websocket rencode bitcoinlib maxminddb pyopenssl rich
  ];

  buildPhase = ''
    ${python3Packages.python.interpreter} -O -m compileall .
  '';

  installPhase = ''
    mkdir -p $out/share
    cp -r plugins src *.py $out/share/
  '';

  postFixup = ''
    makeWrapper "$out/share/zeronet.py" "$out/bin/zeronet" \
      --set PYTHONPATH "$PYTHONPATH" \
      --set PATH ${python3Packages.python}/bin
  '';

  meta = with lib; {
    description = "A fork/continuation of the ZeroNet project";
    longDescription = ''
      zeronet-conservancy is a fork/continuation of ZeroNet project (that has
      been abandoned by its creator) that is dedicated to sustaining existing
      p2p network and developing its values of decentralization and freedom,
      while gradually switching to a better designed network.
    '';
    homepage = "https://github.com/zeronet-conservancy/zeronet-conservancy";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fgaz ];
  };
}
