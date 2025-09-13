{
  autoreconfHook,
  boost,
  cargo,
  coreutils,
  curl,
  cxx-rs,
  db62,
  fetchFromGitHub,
  fetchpatch,
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

let
  # See https://github.com/zcash/zcash/issues/6753
  boost' = boost.overrideAttrs (old: {
    patches = old.patches ++ [
      (fetchpatch {
        url = "https://raw.githubusercontent.com/zcash/zcash/v6.2.0/depends/patches/boost/6753-signals2-function-fix.patch";
        stripLen = 0;
        sha256 = "sha256-LSmGZkswjbT1tDEKabGq/0e4UC6iJoo/8dJLOOHGGls=";
      })
    ];
  });
in
stdenv.mkDerivation rec {
  pname = "zcash";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "zcash";
    repo = "zcash";
    rev = "v${version}";
    hash = "sha256-1jbQfVkvMLqwzj+HoGc1NPkeYWl25nsoguxV93F7DWM=";
  };

  patches = [
    # upstream has a custom way of specifying a cargo vendor-directory
    # we'll remove that logic, since cargoSetupHook from nixpkgs works better
    ./dont-use-custom-vendoring-logic.patch

    # Zcash's compiler does not complain about these missing headers, but
    # the compiler used in nixpkgs does complain.
    ./add-missing-headers.patch

    # Without these changes, linker errors occur due to the ordering of the
    # dependencies. See https://github.com/zcash/zcash/pull/6106 for an example
    # of a nearly identical issue.
    ./reorder-dependencies.patch
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-nx4uELNQuq2VbWa8en4S/PVxDNKQ3NPWMuKArC5NUHM=";
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
    boost'
    db62
    libevent
    libsodium
    tl-expected
    utf8cpp
    zeromq
  ];

  CXXFLAGS = [
    "-Wno-unused-result"
    "-I${lib.getDev utf8cpp}/include/utf8cpp"
    "-I${lib.getDev cxx-rs}/include"
  ];

  configureFlags = [
    "--disable-tests"
    "--with-boost-libdir=${lib.getLib boost'}/lib"
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
