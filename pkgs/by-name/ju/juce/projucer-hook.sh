# shellcheck disable=SC2034

set -e

projucerConfigurePhase() {
  runHook preConfigure

  Projucer --set-global-search-path linux defaultJuceModulePath @src@/modules
  if [ -n "${jucerUserModules-}" ]; then
    Projucer --set-global-search-path linux defaultUserModulePath "$jucerUserModules"
  fi
  Projucer --resave "${jucerFile:-$pname.jucer}"

  runHook postConfigure
}

projucerInstallPhase() {
  runHook preInstall

  find build -maxdepth 1 -executable -type f -not -name "juce_*" | while IFS= read -r -d '' f; do
    # shellcheck disable=SC2154
    mkdir -p "$out"/bin
    cp "$f" "$out"/bin
  done

  runHook postInstall
}

projucerPreBuild() {
  # setting the makefile attribute screws up paths
  cd Builds/LinuxMakefile
}

if [ -z "${dontUseProjucerConfigure-}" ] && [ -z "${configurePhase-}" ]; then
  configurePhase=projucerConfigurePhase
  preBuildHooks+=(projucerPreBuild)
  makeFlags+=(
    all
    "Config=Release"
    "JUCE_VST3DESTDIR=$out/lib/vst3"
    "JUCE_VSTDESTDIR=$out/lib/vst"
    "JUCE_LV2DESTDIR=$out/lib/lv2"
  )
  enableParallelBuilding=true
fi

if [ -z "${dontUseProjucerInstall-}" ] && [ -z "${installPhase-}" ]; then
  installPhase=projucerInstallPhase
fi
