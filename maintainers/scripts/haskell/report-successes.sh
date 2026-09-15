set -euo pipefail

function help {
cat <<END_HELP
Usage: $0

Call nix-build on derivations passed in standard input and report the ones with successful output paths
Can be used in combination with ./sweep-packages.nix to search for unnecessary property overrides by attempting builds with the default value

Examples:
  $0 /nix/store/123-hello.drv /nix/store/456-cowsay.drv
  nix-instantiate sweep-packages.nix -A derivationsWithout.overrideCabal.jailbreak | $0
END_HELP
exit 1
}

if [[ $# > 0 ]]; then
    help
fi

echo "Reading derivations list"
derivations=$(</dev/stdin)
echo "Attempting build - successful derivations will be reported at the end"
echo "To skip to current results press ctrl-c"
nix-build --keep-going $derivations > /dev/null || : # ignore error code here so we can report successes

echo "Checking which derivations actually placed output paths in the store..."
for drv in $derivations; do
    outputs=$(nix-store --query $drv)
    failures=false;
    for out in $outputs; do
        if [[ ! -d $out ]]; then
            failures=true
        fi;
    done;
    if ! $failures; then
        echo $drv
    fi;
done
