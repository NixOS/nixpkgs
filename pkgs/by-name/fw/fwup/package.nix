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
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "fhunleth";
    repo = "fwup";
    rev = "v${version}";
    sha256 = "sha256-h5KUdJ+9/3Oc4/40sn3o8w6zALE7wPGJAtjhsutr55k=";
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
