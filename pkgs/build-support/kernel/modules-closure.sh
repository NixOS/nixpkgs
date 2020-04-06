source $stdenv/setup

# When no modules are built, the $out/lib/modules directory will not
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

# Determine the dependencies of each root module.
closure=
for module in $rootModules; do
    echo "root module: $module"
    deps=$(modprobe --config no-config -d $kernel --set-version "$version" --show-depends "$module" \
        | sed 's/^insmod //') \
        || if test -z "$allowMissing"; then exit 1; fi
    if [[ "$deps" != builtin* ]]; then
        closure="$closure $deps"
    fi
done

echo "closure:"
mkdir -p $out/lib/modules/"$version"
for module in $closure; do
    target=$(echo $module | sed "s^$NIX_STORE.*/lib/modules/^$out/lib/modules/^")
    if test -e "$target"; then continue; fi
    if test \! -e "$module"; then continue; fi # XXX: to avoid error with "cp builtin builtin"
    mkdir -p $(dirname $target)
    echo $module
    cp $module $target
    # If the kernel is compiled with coverage instrumentation, it
    # contains the paths of the *.gcda coverage data output files
    # (which it doesn't actually use...).  Get rid of them to prevent
    # the whole kernel from being included in the initrd.
    nuke-refs $target
    echo $target >> $out/insmod-list
done

mkdir -p $out/lib/firmware
for module in $closure; do
    for i in $(modinfo -F firmware $module); do
        mkdir -p "$out/lib/firmware/$(dirname "$i")"
        echo "firmware for $module: $i"
        cp "$firmware/lib/firmware/$i" "$out/lib/firmware/$i" 2>/dev/null || if test -z "$allowMissing"; then exit 1; fi
    done
done

# copy module ordering hints for depmod
cp $kernel/lib/modules/"$version"/modules.order $out/lib/modules/"$version"/.
cp $kernel/lib/modules/"$version"/modules.builtin $out/lib/modules/"$version"/.

depmod -b $out -a $version

# remove original hints from final derivation
rm $out/lib/modules/"$version"/modules.order
rm $out/lib/modules/"$version"/modules.builtin
