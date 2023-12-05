{ autoreconfHook, boost180, cargo, coreutils, curl, cxx-rs, db62, fetchFromGitHub
, git, hexdump, lib, libevent, libsodium, makeWrapper, rustPlatform
, pkg-config, Security, stdenv, testers, tl-expected, utf8cpp, util-linux, zcash, zeromq
}:

rustPlatform.buildRustPackage.override { inherit stdenv; } rec {
  pname = "zcash";
  version = "5.4.2";

  src = fetchFromGitHub {
    owner = "zcash";
    repo  = "zcash";
    rev = "v${version}";
    hash = "sha256-XGq/cYUo43FcpmRDO2YiNLCuEQLsTFLBFC4M1wM29l8=";
  };

  prePatch = lib.optionalString stdenv.isAarch64 ''
    substituteInPlace .cargo/config.offline \
      --replace "[target.aarch64-unknown-linux-gnu]" "" \
      --replace "linker = \"aarch64-linux-gnu-gcc\"" ""
  '';

  cargoHash = "sha256-Mz8mr/RDcOfwJvXhY19rZmWHP8mUeEf9GYD+3JAPNOw=";

  nativeBuildInputs = [ autoreconfHook cargo cxx-rs git hexdump makeWrapper pkg-config ];

  buildInputs = [
    boost180
    db62
    libevent
    libsodium
    tl-expected
    utf8cpp
    zeromq
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  # Use the stdenv default phases (./configure; make) instead of the
  # ones from buildRustPackage.
  configurePhase = "configurePhase";
  buildPhase = "buildPhase";
  checkPhase = "checkPhase";
  installPhase = "installPhase";

  postPatch = ''
    # Have to do this here instead of in preConfigure because
    # cargoDepsCopy gets unset after postPatch.
    configureFlagsArray+=("RUST_VENDORED_SOURCES=$cargoDepsCopy")
  '';

  CXXFLAGS = [
    "-I${lib.getDev utf8cpp}/include/utf8cpp"
    "-I${lib.getDev cxx-rs}/include"
  ];

  configureFlags = [
    "--disable-tests"
    "--with-boost-libdir=${lib.getLib boost180}/lib"
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
        --set PATH ${lib.makeBinPath [ coreutils curl util-linux ]}
  '';

  meta = with lib; {
    description = "Peer-to-peer, anonymous electronic cash system";
    homepage = "https://z.cash/";
    maintainers = with maintainers; [ rht tkerber centromere ];
    license = licenses.mit;

    # https://github.com/zcash/zcash/issues/4405
    broken = stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isDarwin;
  };
}
