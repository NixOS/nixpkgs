# shellcheck disable=SC2154
mesonSubprojectsHook() {
  if [ -z "${mesonSubprojects-}" ]; then
    echo "ERROR: \$mesonSubprojects is not set."
    exit 1
  fi

  local subprojectsPath="${mesonSubprojectsPath-$sourceRoot/subprojects}"
  rm -r "$subprojectsPath"
  cp -R --no-preserve=mode,ownership "$mesonSubprojects" "$subprojectsPath"
}

postUnpackHooks+=(mesonSubprojectsHook)
