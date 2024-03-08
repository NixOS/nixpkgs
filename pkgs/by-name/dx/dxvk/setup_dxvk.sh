#!@bash@/bin/bash -e

set -eu -o pipefail

# shellcheck disable=SC2034
{
    dxvk32_dir=@dxvk32@/bin
    dxvk64_dir=@dxvk64@/bin

    mcfgthreads32_dir=@mcfgthreads32@/bin
    mcfgthreads64_dir=@mcfgthreads64@/bin
}

## Defaults

declare -A dlls=(
    [d3d9]="dxvk/d3d9.dll"
    [d3d10]="dxvk/d3d10.dll dxvk/d3d10_1.dll dxvk/d3d10core.dll"
    [d3d11]="dxvk/d3d11.dll"
    [dxgi]="dxvk/dxgi.dll"
    [mcfgthreads]="mcfgthreads/mcfgthread-12.dll"
)

declare -A targets=([d3d9]=1 [d3d11]=1 [dxgi]=1 [mcfgthreads]=1)

## Command-line Parsing

usage() {
    echo "DXVK @version@"
    echo "Set up Wine prefix with DXVK DLLs"
    echo
    echo "USAGE"
    echo "    $0 [install|uninstall] [OPTIONS]"
    echo
    echo "COMMANDS"
    echo "    install                  Copy the DXVK DLLs into the prefix"
    echo "    uninstall                Restore the backed up Wine DLLs in the prefix"
    echo
    echo "OPTIONS"
    echo "    --with(out)-dxgi         Copy DXVK DXGI DLL into prefix (default: with DXGI)"
    echo "    --with(out)-d3d10        Copy D3D10 DLLs into prefix (default: without D3D10)"
    echo "    -s, --symlink            Symlink instead of copy"
    echo "    -f, --force              Create a Wine prefix even if it does not exist"
    echo "    -p, --prefix <PREFIX>    Wine prefix to manage (default: \$WINEPREFIX)"
    exit 1
}

case "${1:-}" in
    uninstall|install)
        action=$1
        shift
        ;;
    -h|--help)
        usage
        ;;
    *)
        if [ -n "${1:-}" ]; then
            echo "Unrecognized command: $1"
        fi
        usage
        ;;
esac


do_symlink=false
do_makeprefix=false

while [ -n "${1:-}" ]; do
    case "$1" in
        --with-dxgi)
            targets[dxgi]=1
            ;;
        --without-dxgi)
            unset "targets[dxgi]"
            ;;
        --with-d3d10)
            targets[d3d10]=1
            ;;
        --without-d3d10)
            unset "targets[d3d10]"
            ;;
        -s|--symlink)
            do_symlink=true
            ;;
        --no-symlink)
            do_symlink=false
            ;;
        -f|--force)
            do_makeprefix=true
            ;;
        --no-force)
            do_makeprefix=false
            ;;
        -p|--prefix)
            shift
            if [ -n "${1:-}" ]; then
                WINEPREFIX=$1
            else
                echo "Required PREFIX missing"
                usage
            fi
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unrecognized option: $1"
            usage
            ;;
    esac
    shift
done

## Get information on the Wine environment

export WINEPREFIX=${WINEPREFIX:-"$HOME/.wine"}

# check wine prefix before invoking wine, so that we
# don't accidentally create one if the user screws up
if ! $do_makeprefix && [ -n "$WINEPREFIX" ] && ! [ -f "$WINEPREFIX/system.reg" ]; then
    echo "$WINEPREFIX: Not a valid wine prefix." >&2
    exit 1
fi

export WINEDEBUG=-all
# disable mscoree and mshtml to avoid downloading
# wine gecko and mono
export WINEDLLOVERRIDES="mscoree,mshtml="

wine="wine"
wine64="wine64"
wineboot="wineboot"

# $PATH is the way for user to control where wine is located (including custom Wine versions).
# Pure 64-bit Wine (non Wow64) requries skipping 32-bit steps.
# In such case, wine64 and winebooot will be present, but wine binary will be missing,
# however it can be present in other PATHs, so it shouldn't be used, to avoid versions mixing.
wine_path=$(dirname "$(command -v $wineboot)")
wow64=true
if ! [ -f "$wine_path/$wine" ]; then
   wine=$wine64
   wow64=false
fi

# resolve 32-bit and 64-bit system32 path
winever=$($wine --version | grep wine)
if [ -z "$winever" ]; then
    echo "$wine: Not a wine executable. Check your $wine." >&2
    exit 1
fi

# ensure wine placeholder dlls are recreated
# if they are missing
$wineboot -u

win64_sys_path=$($wine64 winepath -u 'C:\windows\system32' 2> /dev/null)
win64_sys_path="${win64_sys_path/$'\r'/}"
if $wow64; then
  win32_sys_path=$($wine winepath -u 'C:\windows\system32' 2> /dev/null)
  win32_sys_path="${win32_sys_path/$'\r'/}"
fi

if [ -z "${win32_sys_path:-}" ] && [ -z "${win64_sys_path:-}" ]; then
  echo 'Failed to resolve C:\windows\system32.' >&2
  exit 1
fi

## Utility functions

install_file() {
    $do_symlink && file_cmd="ln -sv" || file_cmd="install -m 755 -v"

    srcfile=$1
    dstfile=$2

    if [ -f "${srcfile}.so" ]; then
        srcfile="${srcfile}.so"
    fi

    if ! [ -f "${srcfile}" ]; then
        echo "${srcfile}: File not found. Skipping." >&2
        return 1
    fi

    if [ -n "$1" ]; then
        if [ -f "${dstfile}" ] || [ -h "${dstfile}" ]; then
            if ! [ -f "${dstfile}.old" ]; then
                mv -v "${dstfile}" "${dstfile}.old"
            else
                rm -v "${dstfile}"
            fi
        fi
        $file_cmd "${srcfile}" "${dstfile}"
    else
        echo "${dstfile}: File not found in wine prefix" >&2
        return 1
    fi
}

uninstall_file() {
    srcfile=$1
    dstfile=$2

    if [ -f "${srcfile}.so" ]; then
        srcfile="${srcfile}.so"
    fi

    if ! [ -f "${srcfile}" ]; then
        echo "${srcfile}: File not found. Skipping." >&2
        return 1
    fi

    if ! [ -f "${dstfile}" ] && ! [ -h "${dstfile}" ]; then
        echo "${dstfile}: File not found. Skipping." >&2
        return 1
    fi

    if [ -f "${dstfile}.old" ]; then
        rm -v "${dstfile}"
        mv -v "${dstfile}.old" "${dstfile}"
        return 0
    else
        return 1
    fi
}

install_override() {
    dll=$(basename "$1")
    if ! $wine reg add 'HKEY_CURRENT_USER\Software\Wine\DllOverrides' /v "$dll" /d native /f >/dev/null 2>&1; then
        echo -e "Failed to add override for $dll"
        exit 1
    fi
}

uninstall_override() {
    dll=$(basename "$1")
    if ! $wine reg delete 'HKEY_CURRENT_USER\Software\Wine\DllOverrides' /v "$dll" /f > /dev/null 2>&1; then
        echo "Failed to remove override for $dll"
    fi
}

## Perform the requested command

declare -A paths

for target in "${!targets[@]}"; do
    [ "${targets[$target]}" -eq 1 ] || continue
    for dll in ${dlls[$target]}; do
        dllname=$(basename "$dll")
        basedir=$(dirname "$dll")

        if [ -n "${win32_sys_path:-}" ]; then
            basedir32=${basedir}32_dir
            paths["${!basedir32}/$dllname"]="$win32_sys_path/$dllname"
        fi
        if [ -n "${win64_sys_path:-}" ]; then
            basedir64=${basedir}64_dir
            paths["${!basedir64}/$dllname"]="$win64_sys_path/$dllname"
        fi
    done
done

for srcpath in "${!paths[@]}"; do
    "${action}_file" "$srcpath" "${paths["$srcpath"]}"
    "${action}_override" "$(basename "$srcpath" .dll)"
done
