{ lib
, python3Packages
, fetchFromGitHub
, linkFarm
, secp256k1
, particl-core
, bitcoind
, litecoind
, namecoind
, monero-cli
, wownero
}:

let
  secp256k1_anonswap = secp256k1.overrideAttrs (old: {
    src = fetchFromGitHub {
      owner = "tecnovert";
      repo = "secp256k1";
      rev = "anonswap_v0.2";
      hash = "sha256-EeUyiYLmgWLQFm0ezLETJrOg3QeLHRx2YVbjwvPMB+Q=";
    };
  });
  coincurve-anonswap = (python3Packages.coincurve.override {
    secp256k1 = secp256k1_anonswap;
  }).overrideAttrs (old: {
    src = fetchFromGitHub {
      owner = "tecnovert";
      repo = "coincurve";
      rev = "anonswap_v0.2";
      hash = "sha256-EH8u8aZrBzM+TP2AN1zgtRgW8NMSVdfVQBUh6JQA3yE=";
    };
  });
  bindir = linkFarm "bindir" (lib.mapAttrs (_: p: "${lib.getBin p}/bin") {
    particl = particl-core;
    bitcoin = bitcoind;
    litecoin = litecoind;
    namecoin = namecoind;
    monero = monero-cli;
    wownero = wownero;
    #TODO: add pivx after it's not broken
  });
in
python3Packages.buildPythonApplication {
  pname = "basicswap";
  version = "0.13.4";

  src = fetchFromGitHub {
    owner = "basicswap";
    repo = "basicswap";
    rev = "5e69bf172cf251d8298eb0b4e15f08a099e07ffb";
    hash = "sha256-AUTQCI+qIv57RVVTBK3DC6lotmzOUENEwBRILylwYEw=";
  };

  postPatch = ''
    substituteInPlace basicswap/config.py --replace-fail "os.path.join('~', '.basicswap', 'bin')" ${bindir}
    substituteInPlace bin/basicswap_prepare.py \
      --replace-fail "bin_dir = None" "bin_dir = '${bindir}'" \
      --replace-fail "no_cores = False" "no_cores = True"
  '';

  propagatedBuildInputs = with python3Packages; [
    coincurve-anonswap
    wheel
    pyzmq
    protobuf
    sqlalchemy_1_4
    python-gnupg
    jinja2
    pycryptodome
    pysocks
    mnemonic
  ];

  postInstall = ''
    install -Dm755 scripts/createoffers.py $out/bin/basicswap-createoffers
  '';

  doCheck = false;

  meta = with lib; {
    description = "Basic Atomic Swap Proof of Concept";
    homepage = "https://basicswapdex.com";
    license = licenses.mit;
    maintainers = with maintainers; [ linsui ];
    mainProgram = "basicswap-run";
  };
}
