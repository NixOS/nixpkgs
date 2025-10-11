{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  libpng,
  libtiff,
  zlib,
  lcms2,
  jpipLibSupport ? false, # JPIP library & executables
  jpipServerSupport ? false,
  curl,
  fcgi, # JPIP Server
  jdk,

  # for passthru.tests
  ffmpeg,
  gdal,
  gdcm,
  ghostscript,
  imagemagick,
  leptonica,
  mupdf,
  poppler,
  python3,
  vips,
}:

let
in
stdenv.mkDerivation (finalAttrs: {
  pname = "openjpeg";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "uclouvain";
    repo = "openjpeg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mQ9B3MJY2/bg0yY/7jUJrAXM6ozAHT5fmwES5Q1SGxw=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/uclouvain/openjpeg/issues/1564
      name = "CVE-2024-56826_ISSUE1564.patch";
      url = "https://github.com/uclouvain/openjpeg/commit/e492644fbded4c820ca55b5e50e598d346e850e8.patch";
      hash = "sha256-v+odu4/MXRA+RKOlPO+m/Xk66BMH6mOcEN4ScHn3VAo=";
    })
    (fetchpatch {
      # https://github.com/uclouvain/openjpeg/issues/1563
      name = "CVE-2024-56826_ISSUE1563.patch";
      url = "https://github.com/uclouvain/openjpeg/commit/98592ee6d6904f1b48e8207238779b89a63befa2.patch";
      hash = "sha256-1ScnEZAPuvclyRME5kbeo7dBMG31Njs5CaYC4sGyx08=";
    })
  ];

  outputs = [
    "out"
    "dev"
  ];

  postPatch = lib.optionalString (lib.elem "dev" finalAttrs.outputs) ''
    # Fix OPENJPEG_INSTALL_PACKAGE_DIR, the directory to install OpenJPEG cmake modules.
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        ${lib.escapeShellArg ''set(OPENJPEG_INSTALL_PACKAGE_DIR "''${CMAKE_INSTALL_LIBDIR}/cmake/''${OPENJPEG_INSTALL_SUBDIR}")''} \
        ${lib.escapeShellArg ''set(OPENJPEG_INSTALL_PACKAGE_DIR "${placeholder "dev"}/lib/cmake/''${OPENJPEG_INSTALL_SUBDIR}")''}
  '';

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    "-DBUILD_CODEC=ON"
    "-DBUILD_THIRDPARTY=OFF"
    (lib.cmakeBool "BUILD_JPIP" jpipLibSupport)
    (lib.cmakeBool "BUILD_JPIP_SERVER" jpipServerSupport)
    "-DBUILD_VIEWER=OFF"
    "-DBUILD_JAVA=OFF"
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ]
  ++ lib.optional finalAttrs.doCheck "-DOPJ_DATA_ROOT=${finalAttrs.passthru.test-data}";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libpng
    libtiff
    zlib
    lcms2
  ]
  ++ lib.optionals jpipServerSupport [
    curl
    fcgi
  ]
  ++ lib.optional jpipLibSupport jdk;

  # tests did fail on powerpc64
  doCheck = !stdenv.hostPlatform.isPower64 && stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  checkPhase = ''
    runHook preCheck
    ctest -j $NIX_BUILD_CORES \
          -E '.*jpylyser' --exclude-from-file ${./exclude-tests}
    runHook postCheck
  '';

  passthru = {
    incDir = "openjpeg-${lib.versions.majorMinor finalAttrs.version}";

    # may need to get updated with package
    # https://github.com/uclouvain/openjpeg-data
    test-data = fetchFromGitHub {
      owner = "uclouvain";
      repo = "openjpeg-data";
      rev = "a428429db695fccfc6d698bd13b6937dffd9d005";
      hash = "sha256-udUi7sPNQJ5uCIAM8SqMGee6vRj1QbF9pLjdpNTQE5k=";
    };

    tests = {
      ffmpeg = ffmpeg.override { withOpenjpeg = true; };
      imagemagick = imagemagick.override { openjpegSupport = true; };
      pillow = python3.pkgs.pillow;

      inherit
        gdal
        gdcm
        ghostscript
        leptonica
        mupdf
        poppler
        vips
        ;
    };
  };

  meta = {
    description = "Open-source JPEG 2000 codec written in C language";
    homepage = "https://www.openjpeg.org/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ codyopel ];
    platforms = lib.platforms.all;
    changelog = "https://github.com/uclouvain/openjpeg/blob/v${finalAttrs.version}/CHANGELOG.md";
  };
})
