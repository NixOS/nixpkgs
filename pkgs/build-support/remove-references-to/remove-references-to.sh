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

for target in "${targets[@]}" ; do
    sed -i -e "s|$target|eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee|g" "${regions[@]}"
done

for region in "${regions[@]}"; do
    for hook in "${fixupHooks[@]}"; do
        eval "$hook" "$i"
    done
done
