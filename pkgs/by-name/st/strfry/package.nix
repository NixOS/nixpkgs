{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  openssl,
  lmdb,
  flatbuffers,
  libuv,
  libnotify,
  secp256k1,
  zlib-ng,
  zstd,
}:
stdenv.mkDerivation {
  pname = "strfry";
  version = "1.0.4";
  src = fetchFromGitHub {
    owner = "hoytech";
    repo = "strfry";
    tag = "1.0.4";
    hash = "sha256-2+kPUgyb9ZtC51EK66d3SX2zyqnS6lju2jkIhakcudg";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    perl
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

  postPatch = ''
    patchShebangs golpe/
  '';

  buildPhase = ''
    runHook preBuild
    make -j$NIX_BUILD_CORES
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp ./strfry $out/bin/
    runHook postInstall
  '';

  meta = {
    description = "Nostr relay implementation in C++";
    homepage = "https://github.com/hoytech/strfry";
    mainProgram = "strfry";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felixzieger ];
    platforms = lib.platforms.linux;
  };
}
