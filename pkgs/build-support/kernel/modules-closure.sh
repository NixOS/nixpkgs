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
mkdir -p $out/lib/modules/"$version"
touch closure
for module in $rootModules; do
    echo "root module: $module"
    modprobe --config no-config -d $kernel --set-version "$version" --show-depends "$module" \
    | while read cmd module args; do
        case "$cmd" in
            builtin)
                touch found
                echo "$module" >>closure
                echo "  builtin dependency: $module";;
            insmod)
                touch found
                if ! test -e "$module"; then
                    echo "  dependency not found: $module"
                    exit 1
                fi
                target=$(echo "$module" | sed "s^$NIX_STORE.*/lib/modules/^$out/lib/modules/^")
                if test -e "$target"; then
                    echo "  dependency already copied: $module"
                    continue
                fi
                echo "$module" >>closure
                echo "  copying dependency: $module"
                mkdir -p $(dirname $target)
                cp "$module" "$target"
                # If the kernel is compiled with coverage instrumentation, it
                # contains the paths of the *.gcda coverage data output files
                # (which it doesn't actually use...).  Get rid of them to prevent
                # the whole kernel from being included in the initrd.
                nuke-refs "$target"
                echo "$target" >> $out/insmod-list;;
             *)
                echo "  unexpected modprobe output: $cmd $module"
                exit 1;;
        esac
    done || test -n "$allowMissing"
    if ! test -e found; then
        echo "  not found"
        if test -z "$allowMissing"; then
            exit 1
        fi
    else
        rm found
    fi
done

mkdir -p $out/lib/firmware
for module in $(cat closure); do
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
