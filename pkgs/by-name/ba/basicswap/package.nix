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
  secp256k1_basicswap = secp256k1.overrideAttrs (old: {
    src = fetchFromGitHub {
      owner = "basicswap";
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
  coincurve-basicswap =
    (python3Packages.coincurve.override {
      secp256k1 = secp256k1_basicswap;
    }).overrideAttrs
      {
        version = "21.0.3";
        src = fetchFromGitHub {
          owner = "basicswap";
          repo = "coincurve";
          tag = "basicswap_v0.3";
          hash = "sha256-lSEdwV7jhYa5ERHEVDuLA84JGGVsbvVoOqSRXU5AbCE=";
        };
        patches = [ ];
      };
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
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "basicswap";
  version = "0.18.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "basicswap";
    repo = "basicswap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/n4oirww6k2N0UZBqMtD1M2YvAgMNVd0YZtmsPVZK3U=";
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
    coincurve-basicswap
    wheel
    pyzmq
    python-gnupg
    jinja2
    pycryptodome
    pysocks
    websocket-client
  ];

  postInstall = ''
    install -Dm755 scripts/createoffers.py $out/bin/basicswap-createoffers
  '';

  doCheck = false;

  passthru.bindir = bindir;

  meta = {
    description = "Basic Atomic Swap Proof of Concept";
    homepage = "https://basicswapdex.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ linsui ];
    mainProgram = "basicswap-run";
  };
})
