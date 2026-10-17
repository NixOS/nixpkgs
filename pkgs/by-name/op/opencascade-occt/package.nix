{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  ninja,
  rapidjson,
  tcl,
  tk,
  libGL,
  libGLU,
  libxext,
  libxmu,
  libxi,
  vtk,
  withVtk ? false,
  opencascade-occt,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "opencascade-occt";
  version = "7.9.3";

  src = fetchFromGitHub {
    owner = "Open-Cascade-SAS";
    repo = "OCCT";
    tag = "V${builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-Zp4m+f1wrzynoCrzIwvYELUXsY/NQIBY+HFk5UteufI=";
  };

  patches = lib.optionals (lib.versionOlder finalAttrs.version "7.9") [
    # fix compilation on darwin against latest version of freetype
    # https://gitlab.freedesktop.org/freetype/freetype/-/merge_requests/330
    (fetchpatch {
      url = "https://github.com/Open-Cascade-SAS/OCCT/commit/7236e83dcc1e7284e66dc61e612154617ef715d6.diff";
      hash = "sha256-NoC2mE3DG78Y0c9UWonx1vmXoU4g5XxFUT3eVXqLU60=";
    })
  ];

  # Exclude TKIVtkDraw toolkits cause VTK has no glx support on darwin
  postPatch = lib.optionalString (withVtk && stdenv.hostPlatform.isDarwin) ''
    substituteInPlace adm/MODULES \
      --replace-fail "TKIVtkDraw" ""
  '';

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    tcl
    tk
    libGL
    libGLU
    libxext
    libxmu
    libxi
    rapidjson
  ]
  ++ lib.optional withVtk vtk;

  env.NIX_CFLAGS_COMPILE = toString (
    [ "-fpermissive" ]
    # GCC 16 IPA-CP cloning miscompiles BRepClass3d_SClassifier::Perform, so classifying a point on an edge segfaults
    # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=127917
    # OCCT 8 walks the tree iteratively and is not affected
    ++ lib.optional (
      stdenv.cc.isGNU
      && lib.versionAtLeast stdenv.cc.version "16"
      && lib.versionOlder finalAttrs.version "8"
    ) "-fno-ipa-cp-clone"
  );
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

  # Classifying a point on an edge segfaults when the build is miscompiled, as with GCC 16 without -fno-ipa-cp-clone
  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  installCheckPhase = ''
    runHook preInstallCheck

    export LD_LIBRARY_PATH=$out/lib CASROOT=$out
    export CSF_OCCTResourcePath=$out/share/opencascade/resources
    export DRAWHOME=$CSF_OCCTResourcePath/DrawResources
    export DRAWDEFAULT=$DRAWHOME/DrawDefault CSF_DrawPluginDefaults=$DRAWHOME
    export CSF_StandardDefaults=$CSF_OCCTResourcePath/StdResource
    export CSF_PluginDefaults=$CSF_OCCTResourcePath/StdResource
    cat > classify.tcl <<'EOF'
    pload MODELING
    box b 10 10 10
    point p 0 0 5
    puts [bclassify b p]
    exit
    EOF
    result=$($out/bin/DRAWEXE -b -f classify.tcl 2>&1)
    echo "$result"
    [[ $result == *"The point is ON shape"* ]]

    runHook postInstallCheck
  '';

  passthru = {
    tests = {
      withVtk = opencascade-occt.override { withVtk = true; };
    };
  };

  meta = {
    description = "Open CASCADE Technology, libraries for 3D modeling and numerical simulation";
    homepage = "https://www.opencascade.org/";
    license = lib.licenses.lgpl21; # essentially...
    # The special exception defined in the file OCCT_LGPL_EXCEPTION.txt
    # are basically about making the license a little less share-alike.
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
