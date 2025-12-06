# shellcheck shell=bash

# Setup hook for checking whether Guile imports succeed
echo "Sourcing guileImportsCheckHook.sh"

guileImportsCheckHook () {
  echo "Executing guileImportsCheckHook"

  # the first two decimals of the version are needed
  export GUILE_VERSION="$(@guile@ --version | head -n 1 | awk '{print $4}' | cut -d. -f1,2)"

  # guile can't find the library to import unless we set this
  export GUILE_LOAD_PATH="$out/share/guile/site/$GUILE_VERSION"

  if [[ -n "${guileImportsCheck[*]-}" ]]; then
    # loop through the imports to check
    for i in "${guileImportsCheck[@]}"
    do
      @guile@ -c "(use-modules (${i}))"
    done
  fi
}

appendToVar preDistPhases guileImportsCheckHook
