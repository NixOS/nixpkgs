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

stdenv.mkDerivation (finalAttrs: {
  pname = "fwup";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "fhunleth";
    repo = "fwup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kVkw+/Z3+ZM1wXV/OmfaVPoUKc6MRuz8GRwpvOscuEM=";
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
  ++ lib.optionals finalAttrs.doCheck [
    mtools
    dosfstools
  ];

  nativeCheckInputs = [
    which
    xdelta
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    changelog = "https://github.com/fwup-home/fwup/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Configurable embedded Linux firmware update creator and runner";
    homepage = "https://github.com/fhunleth/fwup";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.georgewhewell ];
    platforms = lib.platforms.all;
  };
})
