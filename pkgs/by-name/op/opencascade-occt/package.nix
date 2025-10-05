{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  cmake,
  ninja,
  rapidjson,
  tcl,
  tk,
  libGL,
  libGLU,
  libXext,
  libXmu,
  libXi,
  vtk,
  withVtk ? false,

  # used in passthru.tests
  opencascade-occt,
}:
stdenv.mkDerivation rec {
  pname = "opencascade-occt";
  version = "7.8.1";
  commit = "V${builtins.replaceStrings [ "." ] [ "_" ] version}";

  src = fetchurl {
    name = "occt-${commit}.tar.gz";
    url = "https://git.dev.opencascade.org/gitweb/?p=occt.git;a=snapshot;h=${commit};sf=tgz";
    hash = "sha256-AGMZqTLLjXbzJFW/RSTsohAGV8sMxlUmdU/Y2oOzkk8=";
  };

  patches = [
    # fix compilation on darwin against latest version of freetype
    # https://gitlab.freedesktop.org/freetype/freetype/-/merge_requests/330
    (fetchpatch {
      url = "https://github.com/Open-Cascade-SAS/OCCT/commit/7236e83dcc1e7284e66dc61e612154617ef715d6.diff";
      hash = "sha256-NoC2mE3DG78Y0c9UWonx1vmXoU4g5XxFUT3eVXqLU60=";
    })

    # patch does not apply against 7.9+, it was submitted upstream for future
    # inclusion: https://github.com/Open-Cascade-SAS/OCCT/pull/683
    ./vtk-draw-conditional-glx.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    tcl
    tk
    libGL
    libGLU
    libXext
    libXmu
    libXi
    rapidjson
  ]
  ++ lib.optional withVtk vtk;

  NIX_CFLAGS_COMPILE = [ "-fpermissive" ];
  cmakeFlags = [
    (lib.cmakeBool "USE_RAPIDJSON" true)
    # Enable exception handling for release builds.
    (lib.cmakeBool "BUILD_RELEASE_DISABLE_EXCEPTIONS" false)
    # cmake 4 compatibility, old versions upstream need like 3 patches to get to a
    # supported version, so just use the big hammer
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.10")
  ]
  ++ lib.optionals withVtk [
    (lib.cmakeBool "USE_VTK" true)
    (lib.cmakeFeature "3RDPARTY_VTK_INCLUDE_DIR" "${lib.getDev vtk}/include/vtk")
  ];

  passthru = {
    tests = {
      withVtk = opencascade-occt.override { withVtk = true; };
    };
  };

  meta = with lib; {
    description = "Open CASCADE Technology, libraries for 3D modeling and numerical simulation";
    homepage = "https://www.opencascade.org/";
    license = licenses.lgpl21; # essentially...
    # The special exception defined in the file OCCT_LGPL_EXCEPTION.txt
    # are basically about making the license a little less share-alike.
    maintainers = with maintainers; [ amiloradovsky ];
    platforms = platforms.all;
  };
}
