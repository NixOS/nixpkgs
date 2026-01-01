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
<<<<<<< HEAD
  version = "1.15.0";
=======
  version = "1.13.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "fhunleth";
    repo = "fwup";
<<<<<<< HEAD
    tag = "v${version}";
    hash = "sha256-kVkw+/Z3+ZM1wXV/OmfaVPoUKc6MRuz8GRwpvOscuEM=";
=======
    rev = "v${version}";
    sha256 = "sha256-s9M734Ohf8kItoOdaxewk4Enbrm2wsT0M4Ak9+q3KA8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/fwup-home/fwup/blob/${src.tag}/CHANGELOG.md";
    description = "Configurable embedded Linux firmware update creator and runner";
    homepage = "https://github.com/fhunleth/fwup";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.georgewhewell ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Configurable embedded Linux firmware update creator and runner";
    homepage = "https://github.com/fhunleth/fwup";
    license = licenses.asl20;
    maintainers = [ maintainers.georgewhewell ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
