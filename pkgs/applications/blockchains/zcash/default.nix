{
  autoreconfHook,
  boost,
  cargo,
  coreutils,
  curl,
  cxx-rs,
  db62,
  fetchFromGitHub,
  gitMinimal,
  hexdump,
  lib,
  libevent,
  libsodium,
  makeWrapper,
  rustc,
  rustPlatform,
  pkg-config,
  stdenv,
  testers,
  tl-expected,
  utf8cpp,
  util-linux,
  zcash,
  zeromq,
}:

stdenv.mkDerivation rec {
  pname = "zcash";
  version = "5.4.2";

  src = fetchFromGitHub {
    owner = "zcash";
    repo = "zcash";
    rev = "v${version}";
    hash = "sha256-XGq/cYUo43FcpmRDO2YiNLCuEQLsTFLBFC4M1wM29l8=";
  };

  patches = [
    # upstream has a custom way of specifying a cargo vendor-directory
    # we'll remove that logic, since cargoSetupHook from nixpkgs works better
    ./dont-use-custom-vendoring-logic.patch
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-VBqasLpxqI4kr73Mr7OVuwb2OIhUwnY9CTyZZOyEElU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    cargo
    cxx-rs
    gitMinimal
    hexdump
    makeWrapper
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    boost
    db62
    libevent
    libsodium
    tl-expected
    utf8cpp
    zeromq
  ];

  CXXFLAGS = [
    "-I${lib.getDev utf8cpp}/include/utf8cpp"
    "-I${lib.getDev cxx-rs}/include"
  ];

  configureFlags = [
    "--disable-tests"
    "--with-boost-libdir=${lib.getLib boost}/lib"
    "RUST_TARGET=${stdenv.hostPlatform.rust.rustcTargetSpec}"
  ];

  enableParallelBuilding = true;

  # Requires hundreds of megabytes of zkSNARK parameters.
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = zcash;
    command = "zcashd --version";
    version = "v${zcash.version}";
  };

  postInstall = ''
    wrapProgram $out/bin/zcash-fetch-params \
        --set PATH ${
          lib.makeBinPath [
            coreutils
            curl
            util-linux
          ]
        }
  '';

  meta = with lib; {
    description = "Peer-to-peer, anonymous electronic cash system";
    homepage = "https://z.cash/";
    maintainers = with maintainers; [
      rht
      tkerber
      centromere
    ];
    license = licenses.mit;

    # https://github.com/zcash/zcash/issues/4405
    broken = stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isDarwin;
  };
}
