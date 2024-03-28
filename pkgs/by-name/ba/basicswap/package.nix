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
  # , pivx
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
    # pivx = pivx;
  });
in
python3Packages.buildPythonApplication {
  pname = "basicswap";
  version = "0.12.7-unstable-2024-03-09";

  src = fetchFromGitHub {
    owner = "tecnovert";
    repo = "basicswap";
    rev = "594845e31268625498cf754d7e9cd1d071ebd6c9";
    hash = "sha256-3g50JHhMeCVBS6/8lDo7/677fQMDslAH6k4EZpONo0c=";
  };

  postPatch = ''
    substituteInPlace basicswap/config.py --replace-fail "~/.basicswap/bin" ${bindir}
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
