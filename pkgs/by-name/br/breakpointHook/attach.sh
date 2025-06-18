#! /usr/bin/env bash

set -eu -o pipefail

# A shell implementation for pgrep as we don't want to depend on procps
pgrep(){
  PATTERN="$1"
  for pid_dir in /proc/[0-9]*; do
    pid="${pid_dir##*/}"

    # Attempt to open /proc/<PID>/cmdline for reading on a new file descriptor
    # If we can't read it (no permission or doesn't exist), skip
    exec {fd}< "$pid_dir/cmdline" 2>/dev/null || continue

    cmdline=""
    # Read each null-delimited token from /proc/<PID>/cmdline
    # and join them with a space for easier pattern matching
    while IFS= read -r -d $'\0' arg <&$fd; do
        if [[ -z "$cmdline" ]]; then
            cmdline="$arg"
        else
            cmdline="$cmdline $arg"
        fi
    done

    # Close the file descriptor
    exec {fd}>&-

    # If cmdline is non-empty and matches the pattern, print the PID
    if [[ -n "$cmdline" && "$cmdline" =~ $PATTERN ]]; then
        echo "$pid"
    fi
  done
}

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

id="$1"
pids="$(pgrep "sleep $id" || :)"
if [ -z "$pids" ]; then
  echo "Error: No process found for 'sleep $id'. The build must still be running in order to attach. Also make sure it's not on a remote builder." >&2
  exit 1s
elif [ "$(echo "$pids" | wc -l)" -ne 1 ]; then
  echo "Error: Multiple processes found matching 'sleep $id'" >&2
  exit 1
fi
pid="$(echo "$pids" | head -n1)"


# get the build top level directory inside the sandbox (eg. /build)
buildDir=$(getVar NIX_BUILD_TOP)

# bash is needed to load the env vars, as we do not know the syntax of the debug shell.
# bashInteractive is used instead of bash, as we depend on it anyways, due to it being
#   the default debug shell
bashInteractive="$(getVar bashInteractive)"
# the debug shell will be started as interactive shell after loading the env vars
debugShell="$(getVar debugShell)"
# to drop the user into the working directory at the point of failure
pwd="$(readlink /proc/$pid/cwd)"

# enter the namespace of the failed build
# bash needs to be executed with --init-file /build/env-vars to include the bash native
#   variables like ones declared via `declare -a`.
# If another shell is chosen via `debugShell`, it will only have simple env vars avaialable.
exec nsenter --mount --ipc --uts --pid  --net --target "$pid" "$bashInteractive" -c "
  set -eu -o pipefail
  source \"$buildDir/env-vars\"
  cd \"$pwd\"
  if [ -n \"$debugShell\" ]; then
    exec \"$debugShell\"
  else
    exec \"$bashInteractive\" --init-file \"$buildDir/env-vars\"
  fi
"
