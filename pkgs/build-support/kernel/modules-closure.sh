source $stdenv/setup

set -o pipefail

PATH=$module_init_tools/sbin:$PATH

version=$(cd $kernel/lib/modules && ls -d *)

echo "kernel version is $version"

export MODULE_DIR=$(readlink -f $kernel/lib/modules/)

# Determine the dependencies of each root module.
closure=
for module in $rootModules; do
    echo "root module: $module"
    deps=$(modprobe --config /dev/null --set-version "$version" --show-depends "$module" \
        | sed 's/^insmod //') \
        || if test -z "$allowMissing"; then exit 1; fi
    #for i in $deps; do echo $i; done
    if [[ "$deps" != builtin* ]]
    then
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

MODULE_DIR=$out/lib/modules/ depmod -a $version
