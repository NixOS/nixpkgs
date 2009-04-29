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
    closure="$closure $deps"
done

echo "closure:"
ensureDir $out
for module in $closure; do
    target=$(echo $module | sed "s^/nix/store/.*/lib/modules/^$out/lib/modules/^")
    if test -e "$target"; then continue; fi
    mkdir -p $(dirname $target)
    echo $module
    cp $module $target
    echo $target >> $out/insmod-list
done

MODULE_DIR=$out/lib/modules/ depmod -a $version
