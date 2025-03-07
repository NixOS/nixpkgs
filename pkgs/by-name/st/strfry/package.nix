{
  lib,
  stdenv,
  fetchFromGitHub,
  gcc,
  perl,
  openssl,
  lmdb,
  flatbuffers,
  libuv,
  libnotify,
  secp256k1,
  zlib-ng,
  git,
  zstd,
}:
stdenv.mkDerivation {
  pname = "strfry";
  version = "1.0.4";
  src = fetchFromGitHub {
    owner = "hoytech";
    repo = "strfry";
    tag = "1.0.4";
    hash = "sha256-2+kPUgyb9ZtC51EK66d3SX2zyqnS6lju2jkIhakcudg=";
    fetchSubmodules = true;
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    gcc
    perl
    git
  ];

  buildInputs = [
    openssl # libssl-dev
    lmdb # liblmdb-dev
    flatbuffers # libflatbuffers-dev
    libuv # libuv1-dev
    libnotify # libnotify-dev
    secp256k1 # libsecp256k1-dev
    zlib-ng # alternative to zlib1g-dev
    zstd # libzstd-dev
  ];

  makeFlags = [ "-j$NIX_BUILD_CORES" ];

  buildPhase = ''
    patchShebangs golpe/
    make -j$NIX_BUILD_CORES
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./strfry $out/bin/
  '';

  meta = {
    description = "Strfry: A nostr relay implementation in C++";
    homepage = "https://github.com/hoytech/strfry";
    mainProgram = "strfry";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felixzieger ];
    platforms = lib.platforms.unix;
  };
}
