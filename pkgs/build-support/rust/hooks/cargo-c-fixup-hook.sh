# shellcheck shell=bash disable=SC2514

cargoCFixupHook() {
  echo "Executing cargoCFixupHook"

  # remove static library archives
  if [ -z "${dontDisableStatic-}" ]; then
    find "${!outputLib}/lib" \( -type f -o -type l \) -name '*.@staticLibrary@' -delete
  fi

  echo "Finished cargoCFixupHook"
}

if [ -z "${dontCargoCFixup-}"]; then
  postFixupHooks+=(cargoCFixupHook)
fi
