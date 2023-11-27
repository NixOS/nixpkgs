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

export allowMissing firmware kernel version out
copy-modules-closure $rootModules

# copy module ordering hints for depmod
cp $kernel/lib/modules/"$version"/modules.order $out/lib/modules/"$version"/.
cp $kernel/lib/modules/"$version"/modules.builtin $out/lib/modules/"$version"/.

depmod -b $out -a $version

# remove original hints from final derivation
rm $out/lib/modules/"$version"/modules.order
rm $out/lib/modules/"$version"/modules.builtin
