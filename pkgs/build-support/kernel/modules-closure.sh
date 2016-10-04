source $stdenv/setup

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

depmod -b $out -a $version
