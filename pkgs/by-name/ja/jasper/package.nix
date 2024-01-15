{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jasper";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "jasper-software";
    repo = "jasper";
    rev = "version-${finalAttrs.version}";
    hash = "sha256-u5380inzLmOT0v6emOtjU3pIEQqTmziAVz1R6QG77x0=";
  };

  outputs = [ "out" "doc" "man" ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  # Since "build" already exists and is populated, cmake tries to use it,
  # throwing uncomprehensible error messages...
  cmakeBuildDir = "build-directory";

  strictDeps = true;

  meta = {
    homepage = "https://jasper-software.github.io/jasper/";
    description = "Image processing/coding toolkit";
    longDescription = ''
      JasPer is a software toolkit for the handling of image data. The software
      provides a means for representing images, and facilitates the manipulation
      of image data, as well as the import/export of such data in numerous
      formats (e.g., JPEG-2000 JP2, JPEG, PNM, BMP, Sun Rasterfile, and
      PGX). The import functionality supports the auto-detection (i.e.,
      automatic determination) of the image format, eliminating the need to
      explicitly identify the format of coded input data. A simple color
      management engine is also provided in order to allow the accurate
      representation of color. Partial support is included for the ICC color
      profile file format, an industry standard for specifying color.

      The JasPer software consists of a library and several application
      programs. The code is written in the C programming language. This language
      was chosen primarily due to the availability of C development environments
      for most computing platforms when JasPer was first developed, circa 1999.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;

    # The value of __STDC_VERSION__ cannot be automatically determined when cross-compiling.
    broken = stdenv.buildPlatform != stdenv.hostPlatform;
  };
})
