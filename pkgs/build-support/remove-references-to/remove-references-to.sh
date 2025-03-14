#! @shell@ -e

fixupHooks=()

if [ -e @out@/nix-support/setup-hooks.sh ]; then
    source @out@/nix-support/setup-hooks.sh
fi

# References to remove
targets=()
while getopts t: o; do
    case "$o" in
        t) storeId=$(echo "$OPTARG" | sed -n "s|^@storeDir@/\\([a-z0-9]\{32\}\\)-.*|\1|p")
           if [ -z "$storeId" ]; then
               echo "-t argument must be a Nix store path"
               exit 1
           fi
           targets+=("$storeId")
    esac
done
shift $(($OPTIND-1))

# Files to remove the references from
regions=()
for i in "$@"; do
    test ! -L "$i" -a -f "$i" && regions+=("$i")
done

if [[ "${#regions[@]}" -eq 0 ]] ; then
    if (( "${NIX_DEBUG:-0}" >= 1 )); then
        echo "removeReferencesTo: no references found" >&2
    fi
    exit 0
fi

for target in "${targets[@]}" ; do
    # We've already checked that "${regions[@]}" is non-empty.
    # If it were empty this would fail with the obscure "sed: no input files".
    sed -i -e "s|$target|eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee|g" "${regions[@]}"
done

for region in "${regions[@]}"; do
    for hook in "${fixupHooks[@]}"; do
        eval "$hook" "$region"
    done
done
