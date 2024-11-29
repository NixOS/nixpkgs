{ stdenv
, callPackage
, rocmUpdateScript
, clang
, xz
, swig
, lua5_3
, graphviz
, gtest
, python3Packages
}:

callPackage ../base.nix rec {
  inherit stdenv rocmUpdateScript;
  buildTests = false; # FIXME: Bad pathing for clang executable in tests, using relative path most likely
  targetName = "lldb";
  targetDir = targetName;
  extraNativeBuildInputs = [ python3Packages.sphinx-automodapi ];

  extraBuildInputs = [
    xz
    swig
    lua5_3
    graphviz
    gtest
  ];

  extraCMakeFlags = [
    "-DLLDB_EXTERNAL_CLANG_RESOURCE_DIR=${clang}/resource-root/lib/clang/$clang_version"
    "-DLLDB_INCLUDE_TESTS=ON"
    "-DLLDB_INCLUDE_UNITTESTS=ON"
  ];

  extraPostPatch = ''
    export clang_version=`clang -v 2>&1 | grep "clang version " | grep -E -o "[0-9.-]+"`
  '';

  checkTargets = [ "check-${targetName}" ];
}
