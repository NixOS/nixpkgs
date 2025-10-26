#!@runtimeShell@

set -euo pipefail

usage() {
  cat "@out@/share/doc/sbetool.txt" >&2
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

files=()
opts=()
opt_regex='^-.+$'
only_files=

for arg in "$@"; do
  if [[ -n $only_files ]] || ! [[ "$arg" =~ $opt_regex ]]; then
    files+=("$arg")
    continue
  fi
  if [[ "$arg" == "-h" ]] || [[ "$arg" == "--help" ]]; then
    usage
    exit 0
  fi
  if [[ "$arg" == "--" ]]; then
    only_files=true
    continue
  fi
  opts+=("$arg")
done

if [[ -z "${files[*]}" ]]; then
  echo "Error: no files provided. If your file starts with -, pass it after -- like this:" >&2
  echo "    sbetool -- -my-file.xml" >&2
  echo >&2
  usage 2>&1 | tail +2 1>&2
  exit 1
fi

# NB: `--add-opens` flag is added because newer version of `agrona` (a utility
# lib used in `sbetool`) depends on jdk.internal.misc.Unsafe
#
# The Unsafe API is deprecated and requires special opt-in to use.
@java@ \
  --add-opens java.base/jdk.internal.misc=ALL-UNNAMED \
  "${opts[@]}" \
  -jar "@tool@/share/sbe/sbe-all-@version@.jar" \
  "${files[@]}"
