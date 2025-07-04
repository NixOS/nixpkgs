cargoInstallPostBuildHook() {
    echo "Executing cargoInstallPostBuildHook"

    releaseDir=target/@targetSubdirectory@/$cargoBuildType
    tmpDir="${releaseDir}-tmp";

    mkdir -p $tmpDir
    cp -r ${releaseDir}/* $tmpDir/
    bins=$(find $tmpDir \
      -maxdepth 1 \
      -type f \
      -executable ! \( -regex ".*\.\(so.[0-9.]+\|so\|a\|dylib\)" \))

    echo "Finished cargoInstallPostBuildHook"
}

cargoInstallHook() {
    echo "Executing cargoInstallHook"

    runHook preInstall

    # rename the output dir to a architecture independent one

    releaseDir=target/@targetSubdirectory@/$cargoBuildType
    tmpDir="${releaseDir}-tmp";

    mapfile -t targets < <(find "$NIX_BUILD_TOP" -type d | grep "${tmpDir}$")
    for target in "${targets[@]}"; do
      rm -rf "$target/../../${cargoBuildType}"
      ln -srf "$target" "$target/../../"
    done
    mkdir -p $out/bin $out/lib

    xargs -r cp -t $out/bin <<< $bins
    find $tmpDir \
      -maxdepth 1 \
      -regex ".*\.\(so.[0-9.]+\|so\|a\|dylib\)" \
      -print0 | xargs -r -0 cp -t $out/lib

    # If present, copy any .dSYM directories for debugging on darwin
    # https://github.com/NixOS/nixpkgs/issues/330036
    find "${releaseDir}" -maxdepth 1 -name '*.dSYM' -exec cp -RLt $out/bin/ {} +

    rmdir --ignore-fail-on-non-empty $out/lib $out/bin
    runHook postInstall

    echo "Finished cargoInstallHook"
}


if [ -z "${dontCargoInstall-}" ] && [ -z "${installPhase-}" ]; then
  installPhase=cargoInstallHook
  postBuildHooks+=(cargoInstallPostBuildHook)
fi
