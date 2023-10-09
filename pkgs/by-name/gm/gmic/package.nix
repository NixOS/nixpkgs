{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, cimg
, cmake
, common-updater-scripts
, coreutils
, curl
, fftw
, gmic-qt
, gnugrep
, gnused
, graphicsmagick
, jq
, libjpeg
, libpng
, libtiff
, ninja
, opencv
, openexr
, pkg-config
, writeShellScript
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gmic";
  version = "3.3.1";

  outputs = [ "out" "lib" "dev" "man" ];

  src = fetchFromGitHub {
    owner = "GreycLab";
    repo = "gmic";
    rev = "v.${finalAttrs.version}";
    hash = "sha256-HagGabJ1jkg5SkMlr0Y5rGFw64jPW8QLuR0I2idM1N0=";
  };

  # TODO: build this from source
  # Reference: src/Makefile, directive gmic_stdlib.h
  gmic_stdlib = fetchurl {
    name = "gmic_stdlib.h";
    url = "http://gmic.eu/gmic_stdlib${lib.replaceStrings ["."] [""] finalAttrs.version}.h";
    hash = "sha256-7JzFU4HvAtC5Nz5vusKCnJ8VMuKfSi1yFmjj0Hh+vA4=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    cimg
    fftw
    graphicsmagick
    libjpeg
    libpng
    libtiff
    opencv
    openexr
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_LIB_STATIC" false)
    (lib.cmakeBool "ENABLE_CURL" false)
    (lib.cmakeBool "ENABLE_DYNAMIC_LINKING" true)
    (lib.cmakeBool "USE_SYSTEM_CIMG" true)
  ];

  postPatch = ''
    cp -r ${finalAttrs.gmic_stdlib} src/gmic_stdlib.h

    # CMake build files were moved to subdirectory.
    mv resources/CMakeLists.txt resources/cmake .
  ''
  + lib.optionalString stdenv.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace "LD_LIBRARY_PATH" "DYLD_LIBRARY_PATH"
  '';

  passthru = {
    tests = {
      # Needs to update them all in lockstep.
      inherit cimg gmic-qt;
    };

    updateScript = writeShellScript "gmic-update-script" ''
      set -o errexit
      PATH=${lib.makeBinPath [ common-updater-scripts coreutils curl gnugrep gnused jq ]}

      latestVersion=$(curl 'https://gmic.eu/files/source/' \
                       | grep -E 'gmic_[^"]+\.tar\.gz' \
                       | sed -E 's/.+<a href="gmic_([^"]+)\.tar\.gz".+/\1/g' \
                       | sort --numeric-sort --reverse | head -n1)

      if [[ "${finalAttrs.version}" = "$latestVersion" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi

      for component in src gmic_stdlib; do
          # The script will not perform an update when the version attribute is
          # up to date from previous platform run; we need to clear it before
          # each run
          update-source-version "--source-key=$component" "gmic" 0 "${lib.fakeHash}"
          update-source-version "--source-key=$component" "gmic" $latestVersion
      done
    '';
  };

  meta = {
    homepage = "https://gmic.eu/";
    description = "Open and full-featured framework for image processing";
    license = lib.licenses.cecill21;
    maintainers = [
      lib.maintainers.AndersonTorres
      lib.maintainers.lilyinstarlight
    ];
    platforms = lib.platforms.unix;
  };
})
