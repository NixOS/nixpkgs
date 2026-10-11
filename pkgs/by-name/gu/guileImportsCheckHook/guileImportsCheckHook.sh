# shellcheck shell=bash

# Setup hook for checking whether Guile imports succeed
echo "Sourcing guileImportsCheckHook.sh"

guileImportsCheckHook () {
  echo "Executing guileImportsCheckHook"

  if [[ -n "${guileImportsCheck[*]-}" ]]; then
    echo "Check whether the following modules can be imported: ${guileImportsCheck[*]}"
    for i in "${guileImportsCheck[@]}"
    do
      # prevent guile from trying to AOT compile during import
      # guile can't find the library to import unless we set this
      GUILE_LOAD_PATH="$out/share/guile/site/@effectiveVersion@" GUILE_AUTO_COMPILE=0 guile -c "(use-modules (${i}))"
    done
  fi
}

appendToVar preDistPhases guileImportsCheckHook
