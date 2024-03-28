## build described at https://wiki.winehq.org/Building_Wine#Shared_WoW64
# shellcheck shell=bash disable=SC2034,SC2154


# Hint ShellCheck we do this
# TODO: Remove once we explicitly specify in ShellCheck directives
# the path to `setup.sh`. See below.
set -eu -o pipefail

# Use directive `shellcheck source=../../../stdenv/generic/setup.sh`
# instead of disabling source following, once setup.sh passes ShellCheck
# See #298831
# shellcheck disable=SC1091
source "$stdenv/setup"
preFlags="${configureFlags[*]-}"

phases="unpackPhase patchPhase" \
  sourceRoot="$TMP/$sourceRoot" \
  genericBuild

configureScript="$TMP/$sourceRoot/configure"
mkdir -p "$TMP/wine-wow" "$TMP/wine64"

cd "$TMP/wine64"
sourceRoot="$(pwd)"
configureFlags="${preFlags} --enable-win64"
phases="configurePhase buildPhase" genericBuild

# Remove 64 bit gstreamer from PKG_CONFIG_PATH
IFS=":" read -ra LIST_ARRAY <<< "$PKG_CONFIG_PATH"
IFS=":" read -ra REMOVE_ARRAY <<< "@pkgconfig64remove@"
NEW_LIST_ARRAY=()

for ELEMENT in "${LIST_ARRAY[@]}"; do
  TO_ADD=1
  for REMOVE in "${REMOVE_ARRAY[@]}"; do
    if [[ "$REMOVE" == "$ELEMENT" ]]; then
      TO_ADD=0
      break
    fi
  done

  if [[ $TO_ADD -eq 1 ]]; then
    NEW_LIST_ARRAY+=("$ELEMENT")
  fi
done
PKG_CONFIG_PATH=$(IFS=":"; echo "${NEW_LIST_ARRAY[*]}")

cd "$TMP/wine-wow"
sourceRoot="$(pwd)"
configureFlags="${preFlags} --with-wine64=../wine64"
phases="configurePhase buildPhase" genericBuild

runHook preInstall
cd "$TMP/wine-wow" && make install "-j$NIX_BUILD_CORES"
cd "$TMP/wine64" && make install "-j$NIX_BUILD_CORES"
runHook postInstall
runPhase fixupPhase
