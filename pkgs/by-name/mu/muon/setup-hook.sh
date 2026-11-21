# shellcheck shell=bash disable=2193

# Gets rid of `build.`-prefixed options in `default_options`.
# See https://docs.muon.build/differences.html#native-true
muonMesonPatchHook() {
  find . \
    -name "meson.build" \
    -exec sed -i -E "/default_options:\s*\[/,/],/ s/('build\.[^']+'),/# \1 # patched by muonMesonPatchHook/" {} \;
}

muonConfigurePhase() {
  runHook preConfigure

  muonConfigureLog=$(mktemp)
  export muonConfigureLog

  : "${muonBuildDir:=build}"

  local flagsArray=()

  if [ -z "${dontAddPrefix-}" ]; then
    # shellcheck disable=2154
    flagsArray+=("-Dprefix=$prefix")
  fi

  if [ -z "${dontDisableStatic-}" ]; then
    flagsArray+=("-Ddefault_library=both")
  fi

  # This most closely reflects meson's configurePhase.
  # See muon’s `muon option -a`.
  # shellcheck disable=2154
  flagsArray+=(
    "-Dlibdir=${!outputLib}/lib"
    "-Dlibexecdir=${!outputLib}/libexec"
    "-Dbindir=${!outputBin}/bin"
    "-Dsbindir=${!outputBin}/sbin"
    "-Dincludedir=${!outputInclude}/include"
    "-Dmandir=${!outputMan}/share/man"
    "-Dinfodir=${!outputInfo}/share/info"
    "-Dlocaledir=${!outputLib}/share/locale"
    "-Dauto_features=${muonAutoFeatures:-enabled}"
    "-Dwrap_mode=${muonWrapMode:-nodownload}"
    "-Dbuildtype=${muonBuildType:-plain}"
  )

  # if pkg-config is in nativeBuildInputs, prefer exec over libpkgconf
  if command -v pkg-config; then
    flagsArray+=("-Dmuon.pkgconfig=exec")
  fi

  # --no-undefined is universally a bad idea on FreeBSD because environ is in the csu
  # shellcheck disable=2050
  if [ "@isFreeBSD@" = "true" ]; then
    flagsArray+=("-Db_lundef=false")
  fi

  concatTo flagsArray muonFlags muonFlagsArray

  echoCmd "muonConfigurePhase flags" "${flagsArray[@]}"

  TERM=dumb muon setup "${flagsArray[@]}" "$muonBuildDir" | tee "$muonConfigureLog"
  cd "$muonBuildDir" || {
    echoCmd "muonConfigurePhase" "could not cd to $muonBuildDir"
    exit 1
  }

  runHook postConfigure
}

muonBuildPhase() {
  runHook preBuild

  local buildCores=1

  # Parallel building is enabled by default.
  if [ "${enableParallelBuilding-1}" ]; then
    buildCores="$NIX_BUILD_CORES"
  fi

  local flagsArray=(
    "-j$buildCores"
  )
  concatTo flagsArray muonBuildFlags muonBuildFlagsArray

  echoCmd "build flags" "${flagsArray[@]}"
  TERM=dumb muon samu "${flagsArray[@]}"

  runHook postBuild
}

muonCheckPhase() {
  runHook preCheck

  # Parallel checking is enabled by default.
  local buildCores=1
  if [ "${enableParallelChecking-1}" ]; then
    buildCores="$NIX_BUILD_CORES"
  fi

  local flagsArray=(
    "-j$buildCores"
    # disable automatic rebuild
    "-R"
    # don't try to display a progress bar, resulting in tons of duplicate lines
    "-ddots"
  )
  concatTo flagsArray muonCheckFlags muonCheckFlagsArray

  echoCmd "muonCheckPhase flags" "${flagsArray[@]}"
  TERM=dumb muon test "${flagsArray[@]}"

  runHook postCheck
}

muonInstallPhase() {
  runHook preInstall

  local flagsArray=()

  concatTo flagsArray muonInstallFlags muonInstallFlagsArray

  echoCmd "muonInstallPhase flags" "${flagsArray[@]}"
  TERM=dumb muon install "${flagsArray[@]}"

  runHook postInstall
}

muonFailureHelperHook() {
  if grep -q "meson.build:[[:digit:]]\+:[[:digit:]]\+: error invalid option 'build\..\+'" "$muonConfigureLog"; then
    echo "------------------------------"
    # shellcheck disable=2016
    echo 'turn on `muonPatchMesonFiles`!'
    echo "------------------------------"
  else
    echo "couldnt find the match"
  fi
}

if [ -n "${muonPatchMesonFiles-}" ]; then
  postPatchHooks+=(muonMesonPatchHook)
fi

if [ -z "${dontUseMuonConfigure-}" ] && [ -z "${configurePhase-}" ]; then
  configurePhase=muonConfigurePhase
fi

# only run the build phase when muon is actually capable of running samu
# shellcheck disable=2050
if [ "@embedSamurai@" = "true" ] && [ -z "${dontUseMuonBuild-}" ] && [ -z "${buildPhase-}" ]; then
  buildPhase=muonBuildPhase
fi

if [ -z "${dontUseMuonCheck-}" ] && [ -z "${checkPhase-}" ]; then
  checkPhase=muonCheckPhase
fi

if [ -z "${dontUseMuonInstall-}" ] && [ -z "${installPhase-}" ]; then
  installPhase=muonInstallPhase
fi

failureHooks+=(muonFailureHelperHook)
