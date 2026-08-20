{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "fverb";
  # no release yet: https://github.com/jpcima/fverb/issues/2
  version = "0-unstable-2020-06-09";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "jpcima";
    repo = "fverb";
    rev = "462020e33e24c0204a375dc95e2c28654cc917b8";
    hash = "sha256-pFVmLW/qau4ZNr+QCKwhrAPsJrJCAoz2mdPbeiw+1Io=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postPatch = ''
    patchShebangs ./dpf/utils/generate-ttl.sh
  '';

  meta = {
    description = "Stereo variant of the reverberator by Jon Dattorro, for lv2";
    homepage = "https://github.com/jpcima/fverb";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.unix;
    # clang++: error: unsupported option '-mfpu=' for target 'arm64-apple-darwin'
    # clang++: error: unsupported option '-mfloat-abi=' for target 'arm64-apple-darwin'
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
  };
}
