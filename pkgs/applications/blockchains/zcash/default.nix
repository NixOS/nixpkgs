{ rust, rustPlatform, stdenv, lib, fetchFromGitHub, autoreconfHook, makeWrapper
, cargo, pkg-config
, bash, curl, coreutils, boost17x, db62, libsodium, libevent, utf8cpp, util-linux
}:

rustPlatform.buildRustPackage rec {
  pname = "zcash";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "zcash";
    repo  = "zcash";
    rev = "v${version}";
    sha256 = "185zrw276g545np0niw5hlhlppkjbf5a1r4rwhnbaimdjdii2dil";
  };

  cargoSha256 = "0qxr6asf8zsya0f1ri39z2cnfpjk96hgwjchz2c7j87vibbvg6dc";

  nativeBuildInputs = [ autoreconfHook cargo makeWrapper pkg-config ];
  buildInputs = [ bash boost17x db62 libevent libsodium utf8cpp ];

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
    "--with-boost-libdir=${lib.getLib boost17x}/lib"
    "CXXFLAGS=-I${lib.getDev utf8cpp}/include/utf8cpp"
    "RUST_TARGET=${rust.toRustTargetSpec stdenv.hostPlatform}"
  ];

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
