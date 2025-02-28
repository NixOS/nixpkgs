{
  lib,
  python3Packages,
  fetchFromGitHub,
  linkFarm,
  secp256k1,
  particl-core,
  bitcoind,
  namecoind,
  monero-cli,
  wownero,
}:

let
  secp256k1_anonswap = secp256k1.overrideAttrs (old: {
    src = fetchFromGitHub {
      owner = "tecnovert";
      repo = "secp256k1";
      rev = "fd8b63ccf8bcb48358a42c456f34e2488a55a688";
      hash = "sha256-/bmKZRBBjirI4YqRKfzoxdAt6UVoWHmrNQQHX7l+eH8=";
    };
    configureFlags = old.configureFlags ++ [
      "--enable-experimental"
      "--enable-module-ed25519"
      "--enable-module-generator"
      "--enable-module-dleag"
      "--enable-module-ecdsaotves"
    ];
  });
  coincurve-anonswap =
    (python3Packages.coincurve.override {
      secp256k1 = secp256k1_anonswap;
    }).overrideAttrs
      (old: {
        src = fetchFromGitHub {
          owner = "tecnovert";
          repo = "coincurve";
          rev = "932366c9d4d8e487162b5c1b2a2d9693e24e0483";
          hash = "sha256-zOekPmP1zR/S+zxq/7OrEz24k8SInlsB+wJ8kPlmqe4=";
        };
      });
  bindir = linkFarm "bindir" (
    lib.mapAttrs (_: p: "${lib.getBin p}/bin") {
      particl = particl-core;
      bitcoin = bitcoind;
      namecoin = namecoind;
      monero = monero-cli;
      wownero = wownero;
      #TODO: add pivx after it's not broken
    }
  );
in
python3Packages.buildPythonApplication rec {
  pname = "basicswap";
  version = "0.14.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "basicswap";
    repo = "basicswap";
    tag = "v${version}";
    hash = "sha256-Ay7MQJdbPDjbtfaIWsegu01KIjlKQqdqH3MomYW7KGc=";
  };

  postPatch = ''
    substituteInPlace basicswap/config.py --replace-fail 'os.path.join("~", ".basicswap", "bin")' '"${bindir}"'
    substituteInPlace basicswap/bin/prepare.py \
      --replace-fail "bin_dir = None" "bin_dir = '${bindir}'" \
      --replace-fail "no_cores = False" "no_cores = True"
  '';

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
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

  passthru.bindir = bindir;

  meta = with lib; {
    description = "Basic Atomic Swap Proof of Concept";
    homepage = "https://basicswapdex.com";
    license = licenses.mit;
    maintainers = with maintainers; [ linsui ];
    mainProgram = "basicswap-run";
  };
}
