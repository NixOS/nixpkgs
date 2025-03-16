# shellcheck shell=bash disable=SC2514

cargoCSetupPhase() {
  echo "Executing cargoCSetupPhase"

  prependToVar cargoCFlags \
    -j "$NIX_BUILD_CORES" \
    --target @rustcTarget@ \
    --frozen

  if [ -z "${dontDisableStatic-}" ]; then
    prependToVar cargoCInstallFlags \
      --library-type cdylib
  fi

  prependToVar cargoCInstallFlags \
    --prefix "$out" \
    --libdir "${!outputLib}/lib" \
    --includedir "${!outputInclude}/include" \
    --bindir "${!outputBin}/bin" \
    --pkgconfigdir "${!outputDev}/lib/pkgconfig"

  echo "Finished cargoCSetupPhase"
}

if [ -z "${dontCargoCSetup-}" ]; then
  prePhases+=(cargoCSetupPhase)
fi
