{
  lib,
  buildGoModule,
  bzip2,
  fetchFromGitHub,
  lz4,
  nixosTests,
  pkg-config,
  rocksdb_9_10,
  snappy,
  stdenv,
  zeromq,
  zlib,
}:

let
  rocksdb = rocksdb_9_10;
in
buildGoModule rec {
  pname = "blockbook";
  version = "0.5.0";
  commit = "657cbcf";

  src = fetchFromGitHub {
    owner = "trezor";
    repo = "blockbook";
    rev = "v${version}";
    hash = "sha256-8/tyqmZE9NJWGg7zYcdei0f1lpXfehy6LM6k5VHW33g=";
  };

  proxyVendor = true;

  vendorHash = "sha256-W29AvzfleCYC2pgHj2OB00PWBTcD2UUDbDH/z5A3bQ4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    bzip2
    lz4
    rocksdb
    snappy
    zeromq
    zlib
  ];

  ldflags = [
    "-X github.com/trezor/blockbook/common.version=${version}"
    "-X github.com/trezor/blockbook/common.gitcommit=${commit}"
    "-X github.com/trezor/blockbook/common.buildDate=unknown"
  ];

  CGO_LDFLAGS = [
    "-L${lib.getLib stdenv.cc.cc}/lib"
    "-lrocksdb"
    "-lz"
    "-lbz2"
    "-lsnappy"
    "-llz4"
    "-lm"
    "-lstdc++"
  ];

  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    ulimit -n 8192
  '';

  subPackages = [ "." ];

  postInstall = ''
    mkdir -p $out/share/
    cp -r $src/static/templates/ $out/share/
    cp -r $src/static/css/ $out/share/
  '';

  passthru.tests = {
    smoke-test = nixosTests.blockbook-frontend;
  };

  meta = with lib; {
    description = "Trezor address/account balance backend";
    homepage = "https://github.com/trezor/blockbook";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      mmahut
    ];
    platforms = platforms.unix;
    mainProgram = "blockbook";
  };
}
