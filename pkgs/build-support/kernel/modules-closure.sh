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

copy_blob() {
    local sourcefile="$firmware/lib/firmware/$2"
    local targetfile="$out/lib/firmware/$2"
    mkdir -p "$out/lib/firmware/$(dirname "$2")"
    echo "firmware for $1: $2"
    if [ -e "$sourcefile" ]; then
        cp -f "$sourcefile" "$targetfile"
    else # if we already copied an uncompressed version there's no point also copying a compressed one
        local found=0
        for extension in "xz" "zstd"; do
            if [ -e "$sourcefile.$extension" ]; then
                found=1
                cp -f "$sourcefile.$extension" "$targetfile.$extension"
            fi
        done
        [ $found -eq 1 ] || echo "WARNING: missing firmware $2 for module $1"
    fi
}

mkdir -p $out/lib/firmware
# copy firmware for loadable modules
for module in $(cat closure); do
    for i in $(modinfo -b $kernel --set-version "$version" -F firmware $module); do
        copy_blob $module "$i"
    done
done
# copy firmware for builtin modules
while IFS=$'\035' read -d '' -r module i; do
    copy_blob $module "$i"
done < <(sed --quiet --null-data --regexp-extended 's/^([^=.]*)\.firmware=(.*)/\1\o035\2/p' $kernel/lib/modules/"$version"/modules.builtin.modinfo) # the file contains ~arbitrary strings so we use sed to parse it correctly

# copy module hints for depmod
cp $kernel/lib/modules/"$version"/modules.{order,builtin{,.modinfo}} -t $out/lib/modules/"$version"

depmod -b $out -a $version

# remove original hints from final derivation
rm $out/lib/modules/"$version"/modules.{order,builtin{,.modinfo}}
