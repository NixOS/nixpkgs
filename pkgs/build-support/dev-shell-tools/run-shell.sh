#!@runtimeShell@

# baked variables, not exported
bashrc='@bashrc@'
bash='@bashInteractive@/bin/bash'

# detected variables and option defaults
shell="$(basename $SHELL)"
mode=interactive

# remaining args
args=()

# parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -c)
      mode=commands
      shift
      break
      ;;
    *)
      mode=exec
      break
      ;;
  esac
done

while [[ $# -gt 0 ]]; do
  args+=("$1")
  shift
done

case "$mode" in
  interactive)
    ;;
  commands)
    if ${#args[@]} -eq 0; then
      echo "nixpkgs: You've requested a command shell, but didn't provide a command."
      echo "         Please provide a command to run."
      exit 1
    fi
    ;;
  exec)
    ;;
esac

invokeWithArgs() {
  bash -c 'source "'"$bashrc"'"; _script="$(shift)"; _args=("$@"); eval "$_script"' -- "$@"
}

# For bash, we'll run the interactive variant of the version Nixpkgs uses.
# For other shells, version correctness can't be a goal, so it's best
# to launch the user's shell from $SHELL. This also avoids bringing in
# dependencies of which N-1 aren't needed. Keeps it quick.
launchBash() {
  case "$mode" in
    interactive)
      exec "$bash" --rcfile "$bashrc" "${args[@]}"
      ;;
    commands)
      exec "$bash" -c 'source "'"$bashrc"'"; _script="$1"; shift; eval "$_script"' -- "${args[@]}"
      ;;
    exec)
      exec "$bash" -c 'source "'"$bashrc"'"; "$@"' -- "${args[@]}"
      ;;
  esac
}

launchShell() {
  case "$shell" in
    bash|"")
      launchBash
      ;;
    *)
      (
        echo "nixpkgs: I see that you weren't running bash. That's cool, but"
        echo "         stdenv derivations are built with bash, so that's what"
        echo "         I'll run for you by default. We'd love to have support"
        echo "         for many shells, so PRs are welcome!"
      ) >&2
      launchBash
      ;;
  esac
}

launchShell
