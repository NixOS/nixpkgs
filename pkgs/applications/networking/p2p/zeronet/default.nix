{ stdenv, fetchFromGitHub, python2Packages }:

python2Packages.buildPythonApplication rec {
  pname = "zeronet";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "HelloZeroNet";
    repo = "ZeroNet";
    rev = "v${version}";
    sha256 = "0v19jjirkyv8hj2yfdj0c40zwynn51h2bj4issn5blr95vhfm8s7";
  };

  propagatedBuildInputs = with python2Packages; [ msgpack gevent ];

  format = "other";

  buildPhase = "${python2Packages.python.interpreter} -O -m compileall .";

  installPhase = ''
    mkdir -p $out/share
    cp -r plugins src tools *.py $out/share/
  '';

  # Wrap the main executable and set the log and data dir to something out of
  # the store
  postFixup = ''
    makeWrapper "$out/share/zeronet.py" "$out/bin/zeronet" \
        --set PYTHONPATH "$PYTHONPATH" \
        --set PATH ${python2Packages.python}/bin \
        --add-flags "--log_dir \$HOME/.local/share/zeronet/logs" \
        --add-flags "--data_dir \$HOME/.local/share/zeronet"
  '';

  meta = with stdenv.lib; {
    description = "Decentralized websites using Bitcoin crypto and BitTorrent network";
    homepage = "https://zeronet.io/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ fgaz ];
  };
}
