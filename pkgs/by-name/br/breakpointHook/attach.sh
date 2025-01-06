#! /usr/bin/env bash

set -eu -o pipefail

id="$1"
pids="$(pgrep -f "sleep $id" || :)"
if [ -z "$pids" ]; then
  echo "Error: No process found for 'sleep $id'. The build must still be running in order to attach. Also make sure it's not on a remote builder." >&2
  exit 1
elif [ "$(echo "$pids" | wc -l)" -ne 1 ]; then
  echo "Error: Multiple processes found matching 'sleep $id'" >&2
  exit 1
fi
pid="$(echo "$pids" | head -n1)"

# helper to extract variables from the build env
getVar(){
  while IFS= read -r -d $'\0' line; do
    case "$line" in
      *"$1="* )
        echo "$line"
        ;;
    esac
  done < /proc/$pid/environ \
  | cut -d "=" -f 2
}

# bash is needed to load the env vars, as we do not know the syntax of the debug shell.
# bashInteractive is used instead of bash, as we depend on it anyways, due to it being
#   the default debug shell
bashInteractive="$(getVar bashInteractive)"
# the debug shell will be started as interactive shell after loading the env vars
debugShell="$(getVar debugShell)"
# to drop the user into the working directory at the point of failure
pwd="$(readlink /proc/$pid/cwd)"

# enter the namespace of the failed build
exec nsenter --mount --net --target "$pid" "$bashInteractive" -c "
  set -eu -o pipefail
  while IFS= read -r -d \$'\0' line; do
    export \"\$line\"
  done <&3
  exec 3>&-
  cd \"$pwd\"
  exec \"$debugShell\"
" 3< /proc/$pid/environ
