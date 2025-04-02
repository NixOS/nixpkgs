set -euo pipefail

function help {
    echo "Usage: $0 PROPERTY [CONFIG]"
    echo
    echo "Search for unnecessary property overrides by attempting builds with the default value"
    echo
    echo "  PROPERTY                  one of {jailbreak, doCheck, doHaddock}"
    echo "  CONFIG                    nix path literal to import config from - see sweep-overrides.nix"
    echo
    echo "Examples:"
    echo "  \$ $0 jailbreak"
    echo "  \$ $0 jailbreak ./config.nix"

    exit 1
}

if [[ $# < 1 ]]; then
    help
fi

property=$1
shift

if [[ $# == 0 ]]; then
    config="{}";
else
    config="(import $1)";
    shift
fi

if [[ $# > 0 ]]; then
    help
fi

dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

expression="with (import $dir/sweep-overrides.nix \"$property\" $config); derivations"

echo "Computing modified derivations"
derivations=$(nix-instantiate -E "$expression" --show-trace)

echo "Attempting build - successful derivations will be reported at the end"
echo "To skip to current results press ctrl-c"
nix-build --keep-going -E "$expression" || : # ignore error code or the script exits

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
