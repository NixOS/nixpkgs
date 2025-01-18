{ lib
, buildGoModule
, bzip2
, fetchFromGitHub
, lz4
, nixosTests
, pkg-config
, rocksdb_7_10
, snappy
, stdenv
, zeromq
, zlib
}:

let
  rocksdb = rocksdb_7_10;
in
buildGoModule rec {
  pname = "blockbook";
  version = "0.4.0";
  commit = "b227dfe";

  src = fetchFromGitHub {
    owner = "trezor";
    repo = "blockbook";
    rev = "v${version}";
    hash = "sha256-98tp3QYaHfhVIiJ4xkA3bUanXwK1q05t+YNroFtBUxE=";
  };

  proxyVendor = true;

  vendorHash = "sha256-n03eWWy+58KAbYnKxI3/ulWIpmR+ivtImQSqbe2kpYU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ bzip2 lz4 rocksdb snappy zeromq zlib ];

  ldflags = [
    "-X github.com/trezor/blockbook/common.version=${version}"
    "-X github.com/trezor/blockbook/common.gitcommit=${commit}"
    "-X github.com/trezor/blockbook/common.buildDate=unknown"
  ];

  tags = [ "rocksdb_7_10" ];

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
    maintainers = with maintainers; [ mmahut _1000101 ];
    platforms = platforms.unix;
    mainProgram = "blockbook";
  };
}
