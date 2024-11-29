{
  stdenv,
  lib,
  patchelf,
  fetchFromGitHub,
  rustPlatform,
  makeBinaryWrapper,
  pkg-config,
  curl,
  openssl,
  xz,
  substituteAll,
  # for passthru.tests:
  edgedb,
  testers,
}:
rustPlatform.buildRustPackage rec {
  pname = "edgedb";
  version = "5.5.2";

  src = fetchFromGitHub {
    owner = "edgedb";
    repo = "edgedb-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-CSs1Ql0zsGgSmZrlZIfj2pJdtAax7HUlfCq8oTbReng=";
    fetchSubmodules = true;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "edgedb-derive-0.5.2" = "sha256-5nvpkmTRcGO4a/Mc+qLp2+u9bWSnHQ/1NT2FW9ii0AU=";
      "edgeql-parser-0.1.0" = "sha256-dhLwBW4ellai9R9TjlJ/qEhZQRXE9D/+QxZsq3I9PRk=";
      "rexpect-0.5.0" = "sha256-vstAL/fJWWx7WbmRxNItKpzvgGF3SvJDs5isq9ym/OA=";
      "scram-0.7.0" = "sha256-QTPxyXBpMXCDkRRJEMYly1GKp90khrwwuMI1eHc2H+Y=";
      "serde_str-1.0.0" = "sha256-CMBh5lxdQb2085y0jc/DrV6B8iiXvVO2aoZH/lFFjak=";
      "test-utils-0.1.0" = "sha256-FoF/U89Q9E2Dlmpoh+cfDcScmhcsSNut+rE7BECJSJI=";
      "warp-0.3.6" = "sha256-knDt2aw/PJ0iabhKg+okwwnEzCY+vQVhE7HKCTM6QbE=";
    };
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs =
    [
      curl
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      xz
    ];

  checkFeatures = [ ];

  patches = [
    (substituteAll {
      src = ./0001-dynamically-patchelf-binaries.patch;
      inherit patchelf;
      dynamicLinker = stdenv.cc.bintools.dynamicLinker;
    })
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = edgedb;
    command = "edgedb --version";
  };

  meta = {
    description = "EdgeDB cli";
    homepage = "https://www.edgedb.com/docs/cli/index";
    license = with lib.licenses; [
      asl20
      # or
      mit
    ];
    maintainers = with lib.maintainers; [
      ahirner
      kirillrdy
    ];
    mainProgram = "edgedb";
  };
}
