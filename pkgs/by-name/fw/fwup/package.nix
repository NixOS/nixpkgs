{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  bzip2,
  libarchive,
  libconfuse,
  libsodium,
  xz,
  zlib,
  coreutils,
  dosfstools,
  mtools,
  unzip,
  zip,
  which,
  xdelta,
}:

stdenv.mkDerivation rec {
  pname = "fwup";
  version = "1.13.2";

  src = fetchFromGitHub {
    owner = "fhunleth";
    repo = "fwup";
    rev = "v${version}";
    sha256 = "sha256-s9M734Ohf8kItoOdaxewk4Enbrm2wsT0M4Ak9+q3KA8=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    bzip2
    libarchive
    libconfuse
    libsodium
    xz
    zlib
  ];

  propagatedBuildInputs = [
    coreutils
    unzip
    zip
  ]
  ++ lib.optionals doCheck [
    mtools
    dosfstools
  ];

  nativeCheckInputs = [
    which
    xdelta
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "Configurable embedded Linux firmware update creator and runner";
    homepage = "https://github.com/fhunleth/fwup";
    license = licenses.asl20;
    maintainers = [ maintainers.georgewhewell ];
    platforms = platforms.all;
  };
}
