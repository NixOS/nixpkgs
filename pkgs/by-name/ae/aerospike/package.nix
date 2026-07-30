{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  cmake,
  libtool,
  openssl,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aerospike-server";
  version = "8.0.0.10";

  src = fetchFromGitHub {
    owner = "aerospike";
    repo = "aerospike-server";
    rev = finalAttrs.version;
    hash = "sha256-RZqlU6vF8w/w8YZRmDV1x/X6tMQ+I1HEwx2WA3zS7mc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    autoconf
    automake
    cmake
    libtool
  ];
  buildInputs = [
    openssl
    zlib
  ];

  dontUseCmakeConfigure = true;

  preBuild = ''
    patchShebangs build/gen_version
    substituteInPlace build/gen_version \
      --replace-fail 'VERSION="$(git describe --abbrev=7)"' 'VERSION="${finalAttrs.version}"' \
      --replace-fail 'CE_SHA="$(git rev-parse HEAD)"' 'CE_SHA="${finalAttrs.version}"' \
      --replace-fail '$(date)' '$(date -u -d "@$SOURCE_DATE_EPOCH" 2>/dev/null || date -u -r "$SOURCE_DATE_EPOCH")'
    patchShebangs build/os_version
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp target/Linux-x86_64/bin/asd $out/bin/asd
  '';

  meta = {
    description = "Flash-optimized, in-memory, NoSQL database";
    mainProgram = "asd";
    homepage = "https://aerospike.com/";
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ kalbasit ];
  };
})
