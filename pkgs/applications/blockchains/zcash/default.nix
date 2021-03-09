{ rust, rustPlatform, stdenv, lib, fetchFromGitHub, autoreconfHook, makeWrapper, fetchpatch
, cargo, pkg-config, bash, curl, coreutils, boost174, db62, hexdump, libsodium, libevent
, utf8cpp, util-linux, withWallet ? true, withDaemon ? true, withUtils ? true
}:

rustPlatform.buildRustPackage.override { stdenv = stdenv; } rec {
  pname = "zcash";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "zcash";
    repo  = "zcash";
    rev = "v${version}";
    sha256 = "00pn1jw8j90y7i8nc92b51znz4gczphvdzbkbcjx63cf6vk7v4ks";
  };

  cargoSha256 = "1rl9sjbvpfrv1mlyb04vw1935qx0kz9cs177xl7izdva1ixk9blr";

  nativeBuildInputs = [ autoreconfHook cargo hexdump makeWrapper pkg-config ];
  buildInputs = [ boost174 libevent libsodium utf8cpp ]
    ++ lib.optional withWallet db62;

  # Use the stdenv default phases (./configure; make) instead of the
  # ones from buildRustPackage.
  configurePhase = "configurePhase";
  buildPhase = "buildPhase";
  checkPhase = "checkPhase";
  installPhase = "installPhase";

  patches = [
    # See https://github.com/zcash/zcash/pull/5015
    (fetchpatch {
      url = "https://github.com/zcash/zcash/commit/a0ac27ec6ed434a233c7ad2468258f6e6e7e9688.patch";
      sha256 = "0pmx1spql9p8vvpjgw7qf3qy46f4mh9ni16bq4ss1xz1z9zgjc4k";
    })
  ];

  postPatch = ''
    # Have to do this here instead of in preConfigure because
    # cargoDepsCopy gets unset after postPatch.
    configureFlagsArray+=("RUST_VENDORED_SOURCES=$NIX_BUILD_TOP/$cargoDepsCopy")
  '';

  configureFlags = [
    "--disable-tests"
    "--with-boost-libdir=${lib.getLib boost174}/lib"
    "CXXFLAGS=-I${lib.getDev utf8cpp}/include/utf8cpp"
    "RUST_TARGET=${rust.toRustTargetSpec stdenv.hostPlatform}"
  ] ++ lib.optional (!withWallet) "--disable-wallet"
    ++ lib.optional (!withDaemon) "--without-daemon"
    ++ lib.optional (!withUtils) "--without-utils";

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
    maintainers = with maintainers; [ rht tkerber ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
