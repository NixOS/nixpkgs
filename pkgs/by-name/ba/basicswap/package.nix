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
      rev = "98679b41ab5f03bcc87a0849405de7dc34be04c4";
      hash = "sha256-09sL1lNMCDM3OfV9oBLubfgUdomhNJ5/pNjeEMViJsI=";
    };
    configureFlags = old.configureFlags ++ [
      "--enable-build-tests=no"
      "--enable-build-exhaustive-tests=no"
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
        version = "21.0.4";
        src = fetchFromGitHub {
          owner = "basicswap";
          repo = "coincurve";
          tag = "basicswap_v0.4";
          hash = "sha256-Aq/Ni6clM/OtbDK0ALwOTOZBit2bWNzVLfzkBku+X1A=";
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
  version = "0.19.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "basicswap";
    repo = "basicswap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2k9Jcsgb1GyN8Sx8lDS9Ql15kVjIXx7LuEeLbzNcQKc=";
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
