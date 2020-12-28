source $stdenv/setup

# When no modules are built, the $kernel/lib/modules directory will not
# exist. Because the rest of the script assumes it does exist, we
# handle this special case first.
if ! test -d "$kernel/lib/modules"; then
    if test -z "$rootModules" || test -n "$allowMissing"; then
        mkdir -p "$out"
        exit 0
    else
        echo "Required modules: $rootModules"
        echo "Can not derive a closure of kernel modules because no modules were provided."
        exit 1
    fi
fi

version=$(cd $kernel/lib/modules && ls -d *)

echo "kernel version is $version"

mkdir -p $out/lib/modules/"$version"
mkdir -p $out/lib/firmware

# Function that copies a kernel module ($1) to $out,
# and bails out if the source path does not exist or
# the target path already exists. Also applies nuke-refs.
copy_module() {
    local modulePath
    modulePath="$1"

    echo "  copy module: $modulePath"
    test -e "$modulePath" || { echo "  module not found: $modulePath"; exit 1; }
    target=$(echo "$modulePath" | sed "s^$NIX_STORE.*/lib/modules/^$out/lib/modules/^")
    test ! -e "$target" || { echo "  module already there: $target"; exit 1; }

    mkdir -p $(dirname $target)
    cp "$modulePath" "$target"

    # If the kernel is compiled with coverage instrumentation, it
    # contains the paths of the *.gcda coverage data output files
    # (which it doesn't actually use...).  Get rid of them to prevent
    # the whole kernel from being included in the initrd.
    nuke-refs "$target"
    echo "$target" >> $out/insmod-list
}

# Function that copies the firmware for a kernel module ($1) to $out.
copy_firmware(){
    local module
    module="$1"
    # for builtin modules, modinfo will reply with a wrong output looking like:
    #   $ modinfo -F firmware unix
    #   name:           unix
    #
    # There is a pending attempt to fix this:
    #   https://github.com/NixOS/nixpkgs/pull/96153
    #   https://lore.kernel.org/linux-modules/20200823215433.j5gc5rnsmahpf43v@blumerang/T/#u
    #
    # For now, the workaround is just to filter out the extraneous lines out
    # of its output.
    for i in $(modinfo -b $kernel --set-version "$version" -F firmware $module | grep -v '^name:'); do
        mkdir -p "$out/lib/firmware/$(dirname "$i")"
        echo "firmware for $module: $i"
        cp "$firmware/lib/firmware/$i" "$out/lib/firmware/$i" 2>/dev/null \
            || echo "WARNING: missing firmware $i for module $module"
    done
}

# Resolve a module name / alias ($1) to (possibly several) module names.
resolve_module(){
    modinfo -b "$kernel" --set-version "$version" -F name "$1"
}

module_not_found(){
    echo "could not find module: $1"
    test -n "$allowMissing" || exit 1;
}

# Compute the filepath of a module ($1).
module_path(){
    modinfo -b "$kernel" --set-version "$version" -F filename "$1"
}

# Extract the dependencies of a module ($1).
extract_depends(){
    modinfo -b "$kernel" --set-version "$version" -F depends "$1" | tr ',' ' '
}

# Create an associative array `modulesArray` of module paths, indexed
# by the module names themselves,
#   modulesArray=([mod1]=mod1Path [mod2]=mod2Path [mod3]=mod3Path ...)
# as well as an associative array `seenModules`, which functions as a set,
# tracking (the names of) all modules already handled.
#   seenModules=([mod1]="seen" ...)
# Also check upfront if any root kernel modules are missing.
declare -A modulesArray
declare -A seenModules
for root in $rootModules; do
    resolved=$(resolve_module "$root") || module_not_found "$root"
    for name in $resolved; do
        echo "resolved root module $root to: $name"
        modulesArray["$name"]=$(module_path "$name")
        seenModules["$name"]="seen"
    done
done


# Compute the dependency closure and call the function add_module
# exactly once for every module (BFS style traversal).
for (( ; ; )); do
    if [ ${#modulesArray[@]} -le 0 ]; then
        # modulesArray is empty, we are done
        break
    fi
    for module in "${!modulesArray[@]}"; do
        modulePath=${modulesArray["$module"]}
        if [ "(builtin)" != "$modulePath" ]; then
            # compute the dependencies
            for dep in $(extract_depends "$module"); do
                resolved=$(resolve_module "$dep") || module_not_found "$dep"
                for name in $resolved; do
                    echo "resolved dependency $dep of module $module to: $name"
                    if ! [ ${seenModules["$name"]+x} ]; then
                        seenModules["$name"]="seen"
                        modulesArray["$name"]=$(module_path "$name")
                    fi
                done
            done
            # copy the module
            copy_module "$modulePath"
        fi
        copy_firmware "$module"
        unset -v modulesArray\["$module"\]
    done
done


# copy module ordering hints for depmod
cp $kernel/lib/modules/"$version"/modules.order $out/lib/modules/"$version"/.
cp $kernel/lib/modules/"$version"/modules.builtin $out/lib/modules/"$version"/.

depmod -b $out -a $version

# remove original hints from final derivation
rm $out/lib/modules/"$version"/modules.order
rm $out/lib/modules/"$version"/modules.builtin
