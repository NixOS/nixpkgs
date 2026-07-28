# shellcheck shell=bash disable=SC2154,SC2034

julecSetEnv() {
  if [ -z "$JULE_SRC_DIR" ]; then
    export JULE_SRC_DIR='./src'
  fi
  if [ -z "$JULE_OUT_DIR" ]; then
    export JULE_OUT_DIR='./bin'
  fi
  if [ -z "$JULE_OUT_NAME" ]; then
    export JULE_OUT_NAME='output'
  fi
  if [ -z "$JULE_TEST_DIR" ]; then
    export JULE_TEST_DIR="$JULE_SRC_DIR"
  fi
  if [ -z "$JULE_TEST_OUT_DIR" ]; then
    export JULE_TEST_OUT_DIR="$JULE_OUT_DIR"
  fi
  if [ -z "$JULE_TEST_OUT_NAME" ]; then
    export JULE_TEST_OUT_NAME="$JULE_OUT_NAME-test"
  fi
}

julecBuildHook() {
  echo "Executing julecBuildHook"

  runHook preBuild

  julecSetEnv
  mkdir -p "$JULE_OUT_DIR"
  julec build --opt L2 -p -o "$JULE_OUT_DIR/$JULE_OUT_NAME" "$JULE_SRC_DIR"

  runHook postBuild

  echo "Finished julecBuildHook"
}

julecCheckHook() {
  echo "Executing julecCheckHook"

  runHook preCheck

  echo "Building tests..."

  julecSetEnv
  mkdir -p "$JULE_TEST_OUT_DIR"
  julec test -o "$JULE_TEST_OUT_DIR/$JULE_TEST_OUT_NAME" "$JULE_TEST_DIR"

  echo "Running tests..."

  "$JULE_TEST_OUT_DIR/$JULE_TEST_OUT_NAME"

  runHook postCheck

  echo "Finished julecCheckHook"
}

julecInstallHook() {
  echo "Executing julecInstallHook"

  runHook preInstall

  julecSetEnv
  mkdir -p "$out/bin"
  cp -r "$JULE_OUT_DIR/$JULE_OUT_NAME" "$out/bin/"

  runHook postInstall

  echo "Finished julecInstallHook"
}

if [ -z "${dontUseJulecBuild-}" ] && [ -z "${buildPhase-}" ]; then
  buildPhase=julecBuildHook
fi
if [ -z "${dontUseJulecCheck-}" ] && [ -z "${checkPhase-}" ]; then
  checkPhase=julecCheckHook
fi
if [ -z "${dontUseJulecInstall-}" ] && [ -z "${installPhase-}" ]; then
  installPhase=julecInstallHook
fi
