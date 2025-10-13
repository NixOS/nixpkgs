{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  libicns,
  imagemagick,
  makeDesktopItem,
  copyDesktopItems,
  cmake,
  python3Packages,
  mpi,
  mpiCheckPhaseHook,
  metis,
  opencascade-occt,
  libGLU,
  zlib,
  tcl,
  tk,
  xorg,
  libjpeg,
  ffmpeg,
  catch2,
  avxSupport ? stdenv.hostPlatform.avxSupport,
  avx2Support ? stdenv.hostPlatform.avx2Support,
  avx512Support ? stdenv.hostPlatform.avx512Support,
}:
let
  archFlags = toString (
    lib.optional avxSupport "-mavx"
    ++ lib.optional avx2Support "-mavx2"
    ++ lib.optional avx512Support "-mavx512"
  );
  patchSource = "https://salsa.debian.org/science-team/netgen/-/raw/debian/6.2.2404+dfsg1-5/debian/patches";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "netgen";
  version = "6.2.2505";

  src = fetchFromGitHub {
    owner = "ngsolve";
    repo = "netgen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MPnibhDzNjqmpW5C76KdeYoZGfKLU0KJ20EnjrK1S+Y=";
  };

  patches = [
    # disable some platform specified code used by downstream ngsolve
    # can be enabled with -march=armv8.3-a+simd when compiling ngsolve
    # note compiling netgen itself is not influenced by this feature
    (fetchpatch2 {
      url = "https://github.com/NGSolve/netgen/pull/197/commits/1d93dfba00f224787cfc2cde1af2ab5d7f5b87f7.patch";
      hash = "sha256-3Nom4uGhGLtSGn/k+qKKSxVxrGtGTHqPtcNn3D/gkZU";
    })

    (fetchpatch2 {
      url = "${patchSource}/use-local-catch2.patch";
      hash = "sha256-h4ob8tl6mvGt5B0qXRFNcl9MxPXxRhYw+PrGr5iRGGk=";
    })
    (fetchpatch2 {
      url = "${patchSource}/ffmpeg_link_libraries.patch";
      hash = "sha256-S02OPH9hbJjOnBm6JMh6uM5XptcubV24vdyEF0FusoM=";
    })
    (fetchpatch2 {
      url = "${patchSource}/fix_nggui_tcl.patch";
      hash = "sha256-ODDT67+RWBzPhhq/equWsu78x9L/Yrs3U8VQ1Uu0zZw=";
    })
    (fetchpatch2 {
      url = "${patchSource}/include_stdlib.patch";
      hash = "sha256-W+NgGBuy/UmzVbPTSqR8FRUlyN/9dl9l9e9rxKklmIc=";
    })
  ];

  # when generating python stub file utilizing system python pybind11_stubgen module
  # cmake need to inherit pythonpath
  postPatch = ''
    sed -i '/-DBDIR=''\'''${CMAKE_CURRENT_BINARY_DIR}/a\
    -DNETGEN_VERSION_GIT=''\'''${NETGEN_VERSION_GIT}
    ' CMakeLists.txt

    substituteInPlace python/CMakeLists.txt \
      --replace-fail ''\'''${CMAKE_INSTALL_PREFIX}/''${NG_INSTALL_DIR_PYTHON}' \
                     ''\'''${CMAKE_INSTALL_PREFIX}/''${NG_INSTALL_DIR_PYTHON}:$ENV{PYTHONPATH}'

    substituteInPlace ng/ng.tcl ng/onetcl.cpp \
      --replace-fail "libnggui" "$out/lib/libnggui"

    substituteInPlace ng/Togl2.1/CMakeLists.txt \
      --replace-fail "/usr/bin/gcc" "$CC"
  ''
  + lib.optionalString (!stdenv.hostPlatform.isx86_64) ''
    # mesh generation differs on x86_64 and aarch64 platform
    # test_tutorials will fail on aarch64 platform
    rm tests/pytest/test_tutorials.py
  '';

  nativeBuildInputs = [
    libicns
    imagemagick
    cmake
    python3Packages.pybind11-stubgen
    python3Packages.pythonImportsCheckHook
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux copyDesktopItems;

  buildInputs = [
    metis
    opencascade-occt
    zlib
    tcl
    tk
    libGLU
    xorg.libXmu
    libjpeg
    ffmpeg
    mpi
    python3Packages.pybind11
  ];

  propagatedBuildInputs = with python3Packages; [
    packaging
    mpi4py
    numpy
  ];

  cmakeFlags = [
    (lib.cmakeFeature "NETGEN_VERSION_GIT" "v${finalAttrs.version}-0")
    (lib.cmakeFeature "NG_INSTALL_DIR_BIN" "bin")
    (lib.cmakeFeature "NG_INSTALL_DIR_LIB" "lib")
    (lib.cmakeFeature "NG_INSTALL_DIR_CMAKE" "lib/cmake/netgen")
    (lib.cmakeFeature "NG_INSTALL_DIR_PYTHON" python3Packages.python.sitePackages)
    (lib.cmakeFeature "NG_INSTALL_DIR_RES" "share")
    (lib.cmakeFeature "NG_INSTALL_DIR_INCLUDE" "include")
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" archFlags)
    (lib.cmakeBool "USE_MPI" true)
    (lib.cmakeBool "USE_MPI4PY" true)
    (lib.cmakeBool "PREFER_SYSTEM_PYBIND11" true)
    (lib.cmakeBool "BUILD_STUB_FILES" true)
    (lib.cmakeBool "USE_SUPERBUILD" false) # use system packages
    (lib.cmakeBool "USE_NATIVE_ARCH" false)
    (lib.cmakeBool "USE_JPEG" true)
    (lib.cmakeBool "USE_MPEG" true)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doInstallCheck)
    (lib.cmakeBool "ENABLE_UNIT_TESTS" finalAttrs.finalPackage.doInstallCheck)
  ];

  __darwinAllowLocalNetworking = true;

  desktopItems = [
    (makeDesktopItem {
      name = "netgen";
      exec = "netgen";
      comment = finalAttrs.meta.description;
      desktopName = "Netgen Mesh Generator";
      genericName = "3D Mesh Generator";
      categories = [ "Science" ];
      icon = "netgen";
    })
  ];

  postInstall =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      rm $out/bin/{Netgen1,startup.sh}
      mkdir -p $out/Applications/netgen.app/Contents/{MacOS,Resources}
      substituteInPlace $out/Info.plist --replace-fail "Netgen1" "netgen"
      mv $out/Info.plist $out/Applications/netgen.app/Contents
      mv $out/Netgen.icns $out/Applications/netgen.app/Contents/Resources
      ln -s $out/bin/netgen $out/Applications/netgen.app/Contents/MacOS/netgen
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      # Extract pngs from the Apple icon image and create
      # the missing ones from the 512x512 image.
      icns2png --extract ../netgen.icns
      for size in 16 24 32 48 64 128 256 512; do
        mkdir -pv $out/share/icons/hicolor/"$size"x"$size"/apps
        if [ -e netgen_"$size"x"$size"x32.png ]
        then
          mv netgen_"$size"x"$size"x32.png $out/share/icons/hicolor/"$size"x"$size"/apps/netgen.png
        else
          convert -resize "$size"x"$size" netgen_512x512x32.png $out/share/icons/hicolor/"$size"x"$size"/apps/netgen.png
        fi
      done;
    '';

  doInstallCheck = true;

  preInstallCheck = ''
    export PYTHONPATH=$out/${python3Packages.python.sitePackages}:$PYTHONPATH
  '';

  installCheckTarget = "test";

  nativeInstallCheckInputs = [
    catch2
    python3Packages.pytest
    python3Packages.pytest-check
    python3Packages.pytest-mpi
    mpiCheckPhaseHook
  ];

  pythonImportsCheck = [ "netgen" ];

  passthru = {
    inherit avxSupport avx2Support avx512Support;
  };

  meta = {
    homepage = "https://ngsolve.org";
    downloadPage = "https://github.com/NGSolve/netgen";
    description = "Atomatic 3d tetrahedral mesh generator";
    license = with lib.licenses; [
      lgpl2Plus
      lgpl21Plus
      lgpl21Only
      bsd3
      boost
      publicDomain
    ];
    platforms = lib.platforms.unix;
    mainProgram = "netgen";
    maintainers = with lib.maintainers; [ qbisi ];
  };
})
