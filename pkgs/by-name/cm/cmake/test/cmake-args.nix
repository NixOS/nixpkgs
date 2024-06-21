{
  lib,
  runCommandCC,
  runCommandLocal,
  writeShellScriptBin,
  cmake,
}:
let
  getOptionalAttrs = names: attrs:
    lib.getAttrs (lib.intersectLists (lib.attrNames attrs) names) attrs;
  write-args = writeShellScriptBin "write-args" ''
    for _line in "$@"; do
      echo "$_line"
    done
  '';
in
runCommandCC "cmake-args-no-structured-attrs" ({
  outputs = [ "out" ];
  __structuredAttrs = false;
  nativeBuildInputs = [
    (runCommandLocal "cmake-setup-hooks" {
      inherit (cmake) setupHooks;
    } ''
      mkdir -p "$out"
      runPhase fixupPhase
    '')
  ];
  buildPhase = "ninjaBuildPhase";
  cmakeFlags = [
    "-DALPHA=from_cmakeFlags_alpha"
    "-DBETA=from_cmakeFlags_beta"
    "-DGAMMA=from_cmakeFlags_gamma"
    "-DCMAKE_INSTALL_INFODIR=${placeholder "out"}/share/info.old"
  ];
  preConfigure = ''
    cmakeFlagsArray+=( \
      "-DGAMMA=from_cmakeFlagsArray_gamma" \
      "-DDELTA=from_cmakeFlagsArray_delta" \
    )
    stat CMakeLists.txt
  '';
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    (
      while IFS= read -r arg; do
        case "$arg" in
        -D*)
          declare "''${arg/-D/}"
        esac
      done < "$out"
      set -x
      [[ "$CMAKE_INSTALL_BINDIR" == "${placeholder "out"}/bin" ]]
      [[ "$CMAKE_INSTALL_INFODIR" == "${placeholder "out"}/share/info.old" ]]
      [[ "$ALPHA" == "from_cmakeFlags_alpha" ]]
      [[ "$BETA" == "from_cmakeFlags_beta" ]]
      [[ "$GAMMA" == "from_cmakeFlagsArray_gamma" ]]
      [[ "$DELTA" == "from_cmakeFlagsArray_delta" ]]
      set +x
    )
    grep -- "-GNinja" "$out"
    runHook postInstallCheck
  '';
} // getOptionalAttrs [
  "prePhases"
  "src" "srcs"
  "unpackPhase" "dontUnpack" "preUnpack" "postUnpack" "unpackCmd"
  "sourceRoot" "setSourceRoot"
  "patchPhase" "dontPatch" "prePatch" "postPatch" "patches" "patchFlags"
  "preConfigurePhases"
] cmake) ''
  touch "$out"
  cmake() {
    ${lib.getExe write-args} "$@" | tee "$out"
  }
  runPhase unpackPhase
  runPhase patchPhase
  runPhase configurePhase
  runPhase installCheckPhase
''
