#! @shell@ -e
path_backup="$PATH"
if [ -n "@coreutils@" ]; then
  PATH="@coreutils@/bin"
fi

if [ -n "$NIX_LD_WRAPPER_START_HOOK" ]; then
    source "$NIX_LD_WRAPPER_START_HOOK"
fi

if [ -z "$NIX_CC_WRAPPER_FLAGS_SET" ]; then
    source @out@/nix-support/add-flags.sh
fi

source @out@/nix-support/utils.sh


# Optionally filter out paths not refering to the store.
params=("$@")
if [ "$NIX_ENFORCE_PURITY" = 1 -a -n "$NIX_STORE" \
        -a \( -z "$NIX_IGNORE_LD_THROUGH_GCC" -o -z "$NIX_LDFLAGS_SET" \) ]; then
    rest=()
    n=0
    while [ $n -lt ${#params[*]} ]; do
        p=${params[n]}
        p2=${params[$((n+1))]}
        if [ "${p:0:3}" = -L/ ] && badPath "${p:2}"; then
            skip $p
        elif [ "$p" = -L ] && badPath "$p2"; then
            n=$((n + 1)); skip $p2
        elif [ "$p" = -rpath ] && badPath "$p2"; then
            n=$((n + 1)); skip $p2
        elif [ "$p" = -dynamic-linker ] && badPath "$p2"; then
            n=$((n + 1)); skip $p2
        elif [ "${p:0:1}" = / ] && badPath "$p"; then
            # We cannot skip this; barf.
            echo "impure path \`$p' used in link" >&2
            exit 1
        elif [ "${p:0:9}" = --sysroot ]; then
            # Our ld is not built with sysroot support (Can we fix that?)
            :
        else
            rest=("${rest[@]}" "$p")
        fi
        n=$((n + 1))
    done
    params=("${rest[@]}")
fi


extra=()
extraBefore=()

if [ -z "$NIX_LDFLAGS_SET" ]; then
    extra+=($NIX_LDFLAGS)
    extraBefore+=($NIX_LDFLAGS_BEFORE)
fi

extra+=($NIX_LDFLAGS_AFTER)


# Add all used dynamic libraries to the rpath.
if [ "$NIX_DONT_SET_RPATH" != 1 ]; then

    libPath=""
    addToLibPath() {
        local path="$1"
        if [ "${path:0:1}" != / ]; then return 0; fi
        case "$path" in
            *..*|*./*|*/.*|*//*)
                local path2
                if path2=$(readlink -f "$path"); then
                    path="$path2"
                fi
                ;;
        esac
        case $libPath in
            *\ $path\ *) return 0 ;;
        esac
        libPath="$libPath $path "
    }

    addToRPath() {
        # If the path is not in the store, don't add it to the rpath.
        # This typically happens for libraries in /tmp that are later
        # copied to $out/lib.  If not, we're screwed.
        if [ "${1:0:${#NIX_STORE}}" != "$NIX_STORE" ]; then return 0; fi
        case $rpath in
            *\ $1\ *) return 0 ;;
        esac
        rpath="$rpath $1 "
    }

    libs=""
    addToLibs() {
        libs="$libs $1"
    }

    rpath=""

    # First, find all -L... switches.
    allParams=("${params[@]}" ${extra[@]})
    n=0
    while [ $n -lt ${#allParams[*]} ]; do
        p=${allParams[n]}
        p2=${allParams[$((n+1))]}
        if [ "${p:0:3}" = -L/ ]; then
            addToLibPath ${p:2}
        elif [ "$p" = -L ]; then
            addToLibPath ${p2}
            n=$((n + 1))
        elif [ "$p" = -l ]; then
            addToLibs ${p2}
            n=$((n + 1))
        elif [ "${p:0:2}" = -l ]; then
            addToLibs ${p:2}
        elif [ "$p" = -dynamic-linker ]; then
            # Ignore the dynamic linker argument, or it
            # will get into the next 'elif'. We don't want
            # the dynamic linker path rpath to go always first.
            n=$((n + 1))
        elif [[ "$p" =~ ^[^-].*\.so($|\.) ]]; then
            # This is a direct reference to a shared library, so add
            # its directory to the rpath.
            path="$(dirname "$p")";
            addToRPath "${path}"
        fi
        n=$((n + 1))
    done

    # Second, for each directory in the library search path (-L...),
    # see if it contains a dynamic library used by a -l... flag.  If
    # so, add the directory to the rpath.
    # It's important to add the rpath in the order of -L..., so
    # the link time chosen objects will be those of runtime linking.

    for i in $libPath; do
        for j in $libs; do
            if [ -f "$i/lib$j.so" ]; then
                addToRPath $i
                break
            fi
        done
    done


    # Finally, add `-rpath' switches.
    for i in $rpath; do
        extra+=(-rpath $i)
    done
fi


# Only add --build-id if this is a final link. FIXME: should build gcc
# with --enable-linker-build-id instead?
if [ "$NIX_SET_BUILD_ID" = 1 ]; then
    for p in "${params[@]}"; do
        if [ "$p" = "-r" -o "$p" = "--relocatable" -o "$p" = "-i" ]; then
            relocatable=1
            break
        fi
    done
    if [ -z "$relocatable" ]; then
        extra+=(--build-id)
    fi
fi


# Don't allow undefined symbols in shared libraries.
if [ "$NIX_ENFORCE_NO_SHLIB_UNDEFINED" = 1 ]; then
    extra+=(--no-allow-shlib-undefined)
fi


# Optionally print debug info.
if [ -n "$NIX_DEBUG" ]; then
  echo "original flags to @prog@:" >&2
  for i in "${params[@]}"; do
      echo "  $i" >&2
  done
  echo "extra flags to @prog@:" >&2
  for i in ${extra[@]}; do
      echo "  $i" >&2
  done
fi

if [ -n "$NIX_LD_WRAPPER_EXEC_HOOK" ]; then
    source "$NIX_LD_WRAPPER_EXEC_HOOK"
fi

PATH="$path_backup"
exec @prog@ ${extraBefore[@]} "${params[@]}" ${extra[@]}
