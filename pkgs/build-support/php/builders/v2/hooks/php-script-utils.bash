# shellcheck shell=bash

declare -g version
declare -g -i composerStrictValidation="${composerStrictValidation:-0}"

setComposerRootVersion() {
  if [[ -n $version ]]; then
    echo -e "\e[32mSetting COMPOSER_ROOT_VERSION to $version\e[0m"
    export COMPOSER_ROOT_VERSION="$version"
  fi
}

setComposerEnvVariables() {
  echo -e "\e[32mSetting some required environment variables for Composer...\e[0m"
  export COMPOSER_MIRROR_PATH_REPOS=1
  export COMPOSER_HTACCESS_PROTECT=0
  export COMPOSER_FUND=0
}

checkComposerValidate() {
  command="composer validate --strict --quiet --no-interaction --no-check-all --no-check-lock"
  if ! $command; then
    echo
    echo -e "\e[31mERROR: composer files validation failed\e[0m"
    echo
    echo -e '\e[31mThe validation of the composer.json failed.\e[0m'
    echo -e '\e[31mMake sure that the file composer.json is valid.\e[0m'
    echo
    echo -e '\e[31mTo address the issue efficiently, follow one of these steps:\e[0m'
    echo -e '\e[31m  1. File an issue in the project'\''s issue tracker with detailed information, and apply any available remote patches as a temporary solution '\('with fetchpatch'\)'.\e[0m'
    echo -e '\e[31m  2. If an immediate fix is needed or if reporting upstream isn'\''t suitable, develop a temporary local patch.\e[0m'
    echo

    if [[ "${composerStrictValidation}" == "1" ]]; then
      echo
      echo -e '\e[33mThis check is blocking, set the attribute composerStrictValidation to false to make it not blocking.\e[0m'
      echo
      exit 1
    else
      echo
      echo -e '\e[33mThis check is not blocking, but it is recommended to fix the issue.\e[0m'
      echo
    fi
  fi

  command="composer validate --strict --no-ansi --no-interaction --quiet --no-check-all --check-lock"
  if ! $command; then
    echo
    echo -e "\e[31mERROR: composer files validation failed\e[0m"
    echo
    echo -e '\e[31mThe validation of the composer.json and composer.lock failed.\e[0m'
    echo -e '\e[31mMake sure that the file composer.lock is consistent with composer.json.\e[0m'
    echo
    echo -e '\e[31mThis often indicates an issue with the upstream project, which can typically be resolved by reporting the issue to the relevant project maintainers.\e[0m'
    echo
    echo -e '\e[31mTo address the issue efficiently, follow one of these steps:\e[0m'
    echo -e '\e[31m  1. File an issue in the project'\''s issue tracker with detailed information '\('run '\''composer update --lock --no-install'\'' to fix the issue'\)', and apply any available remote patches as a temporary solution with '\('with fetchpatch'\)'.\e[0m'
    echo -e '\e[31m  2. If an immediate fix is needed or if reporting upstream isn'\''t suitable, develop a temporary local patch.\e[0m'
    echo

    if [[ "${composerStrictValidation}" == "1" ]]; then
      echo
      echo -e '\e[33mThis check is blocking, set the attribute composerStrictValidation to false to make it not blocking.\e[0m'
      echo
      exit 1
    else
      echo
      echo -e '\e[33mThis check is not blocking, but it is recommended to fix the issue.\e[0m'
      echo
    fi
  fi
}
