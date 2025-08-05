appendToVar postFetchHooks fixVersioneerSource

fixVersioneerSource() {
  local versionfile
  # try pyproject.toml
  versionfile="$([ -f "$out/pyproject.toml" ] && awk 'match($0, /^versionfile_source ?= ?['"'"'"](.*)['"'"'"]/, m) { print m[1] }' "$out/pyproject.toml" || true)"
  if [ -z "$versionfile" ]; then
    echo "'versionfile_source' not found in 'pyproject.toml', trying 'setup.cfg'"
    # try setup.cfg
    versionfile="$([ -f "$out/pyproject.toml" ] && awk 'match($0, /^versionfile_source ?= ?(.*)/, m) { print m[1] }' "$out/setup.cfg" || true)"
    if [ -z "$versionfile" ]; then
      echo "'versionfile_source' not found in 'setup.cfg'"
      return
    fi
  fi
  echo "found versionfile_source = $versionfile"
  sed -i 's/git_refnames = " (.*\(tag:[^,)]*\).*)"/git_refnames = " (\1)"/' "$out/$versionfile"
}
