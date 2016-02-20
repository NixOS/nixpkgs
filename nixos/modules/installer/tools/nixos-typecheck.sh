#! /bin/sh
#! @shell@

if [ -x "@shell@" ]; then export SHELL="@shell@"; fi;

set -e

showSyntax() {
cat >&1 << EOF
nixos-typecheck
usage:
  nixos-typecheck [action] [args]
where:
  action = silent | printAll | printUnspecified | getSpecs
    with default action: printUnspecified
  args = any argument supported by nix-build
EOF
}


# Parse the command line.
extraArgs=()
action=printUnspecified

while [ "$#" -gt 0 ]; do
    i="$1"; shift 1
    case "$i" in
      --help)
        showSyntax
        ;;
      silent|printAll|printUnspecified|getSpecs)
        action="$i"
        ;;
      *)
        extraArgs="$extraArgs $i"
        ;;
    esac
done


if [ "$action" = silent ]; then
    nix-build --no-out-link '<nixpkgs/nixos>' -A typechecker.silent $extraArgs
elif [ "$action" = printAll ]; then
    nix-build --no-out-link '<nixpkgs/nixos>' -A typechecker.printAll $extraArgs
elif [ "$action" = printUnspecified ]; then
    nix-build --no-out-link '<nixpkgs/nixos>' -A typechecker.printUnspecified $extraArgs
elif [ "$action" = getSpecs ]; then
    ln -s $(nix-build --no-out-link '<nixpkgs/nixos>' -A typechecker.specifications $extraArgs)/share/doc/nixos/options-specs.json specifications.json
else
    showSyntax
    exit 1
fi
