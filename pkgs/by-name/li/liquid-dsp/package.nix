{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  darwin,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation rec {
  pname = "liquid-dsp";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "jgaeddert";
    repo = "liquid-dsp";
    rev = "v${version}";
    sha256 = "sha256-IvWtoXuuIvpJfY4cyRUsPHgax2/aytYShSdxEStiPYI=";
  };

  patches = [
    # Fix CMake absolute include/lib paths issue, see also
    # - https://github.com/NixOS/nixpkgs/issues/144170
    # - https://github.com/jgaeddert/liquid-dsp/pull/450
    ./fix-cmake-pc-paths.patch
    # liquid.h uses va_list; needs stdarg.h
    ./include-stdarg.patch
  ];

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.autoSignDarwinBinariesHook
    fixDarwinDylibNames
  ];

  cmakeFlags = [
    # Prevent native cpu arch from leaking into binaries.
    (lib.cmakeBool "ENABLE_SIMD" false)
    (lib.cmakeBool "FIND_SIMD" false)
  ];

  doCheck = true;

  meta = {
    homepage = "https://liquidsdr.org/";
    description = "Digital signal processing library for software-defined radios";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ iank ];
  };
}
