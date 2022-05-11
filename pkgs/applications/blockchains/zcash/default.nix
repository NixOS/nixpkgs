{ rust, rustPlatform, stdenv, lib, fetchFromGitHub, fetchpatch, autoreconfHook
, makeWrapper, cargo, pkg-config, curl, coreutils, boost178, db62, hexdump
, libsodium, libevent, utf8cpp, util-linux, withDaemon ? true, withMining ? true
, withUtils ? true, withWallet ? true, withZmq ? true, zeromq
}:

rustPlatform.buildRustPackage.override { stdenv = stdenv; } rec {
  pname = "zcash";
  version = "4.7.0";

  src = fetchFromGitHub {
    owner = "zcash";
    repo  = "zcash";
    rev = "v${version}";
    sha256 = "sha256-yF+/QepSiZwsdZydWjvxDIFeFyJbJyqZmCdMyQHmrzI=";
  };

  prePatch = lib.optionalString stdenv.isAarch64 ''
    substituteInPlace .cargo/config.offline \
      --replace "[target.aarch64-unknown-linux-gnu]" "" \
      --replace "linker = \"aarch64-linux-gnu-gcc\"" ""
  '';

  cargoPatches = [
    (fetchpatch {
      url = "https://github.com/zcash/zcash/commit/61cd19a52d41d60c1987ecf269f7aa8e4d527310.diff";
      sha256 = "sha256-/7T2yCSVlRN7qfFjrZlfBNMlbVHb/KRjtUBY2xFr0mo=";
    })
  ];

  cargoSha256 = "sha256-+BLfO5OnCBqQTIqMXKJdoPCRgtENa+m0WOHKG9gkdMk=";

  nativeBuildInputs = [ autoreconfHook cargo hexdump makeWrapper pkg-config ];
  buildInputs = [ boost178 libevent libsodium utf8cpp ]
    ++ lib.optional withWallet db62
    ++ lib.optional withZmq zeromq;

  # Use the stdenv default phases (./configure; make) instead of the
  # ones from buildRustPackage.
  configurePhase = "configurePhase";
  buildPhase = "buildPhase";
  checkPhase = "checkPhase";
  installPhase = "installPhase";

  postPatch = ''
    # Have to do this here instead of in preConfigure because
    # cargoDepsCopy gets unset after postPatch.
    configureFlagsArray+=("RUST_VENDORED_SOURCES=$NIX_BUILD_TOP/$cargoDepsCopy")
  '';

  configureFlags = [
    "--disable-tests"
    "--with-boost-libdir=${lib.getLib boost178}/lib"
    "CXXFLAGS=-I${lib.getDev utf8cpp}/include/utf8cpp"
    "RUST_TARGET=${rust.toRustTargetSpec stdenv.hostPlatform}"
  ] ++ lib.optional (!withWallet) "--disable-wallet"
    ++ lib.optional (!withDaemon) "--without-daemon"
    ++ lib.optional (!withUtils) "--without-utils"
    ++ lib.optional (!withMining) "--disable-mining";

  enableParallelBuilding = true;

  # Requires hundreds of megabytes of zkSNARK parameters.
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/zcash-fetch-params \
        --set PATH ${lib.makeBinPath [ coreutils curl util-linux ]}
  '';

  meta = with lib; {
    description = "Peer-to-peer, anonymous electronic cash system";
    homepage = "https://z.cash/";
    maintainers = with maintainers; [ rht tkerber centromere ];
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
