#! @shell@ -e

if test -n "$NIX_LD_WRAPPER_START_HOOK"; then
    . "$NIX_LD_WRAPPER_START_HOOK"
fi

if test -z "$NIX_GLIBC_FLAGS_SET"; then
    . @out@/nix-support/add-flags
fi

. @out@/nix-support/utils


# Optionally filter out paths not refering to the store.
params=("$@")
if test "$NIX_ENFORCE_PURITY" = "1" -a -n "$NIX_STORE" \
        -a \( -z "$NIX_IGNORE_LD_THROUGH_GCC" -o -z "$NIX_LDFLAGS_SET" \); then
    rest=()
    n=0
    while test $n -lt ${#params[*]}; do
        p=${params[n]}
        p2=${params[$((n+1))]}
        if test "${p:0:3}" = "-L/" && badPath "${p:2}"; then
            skip $p
        elif test "$p" = "-L" && badPath "$p2"; then
            n=$((n + 1)); skip $p2
        elif test "$p" = "-rpath" && badPath "$p2"; then
            n=$((n + 1)); skip $p2
        elif test "$p" = "-dynamic-linker" && badPath "$p2"; then
            n=$((n + 1)); skip $p2
        elif test "${p:0:1}" = "/" && badPath "$p"; then
            # We cannot skip this; barf.
            echo "impure path \`$p' used in link" >&2
            exit 1
        else
            rest=("${rest[@]}" "$p")
        fi
        n=$((n + 1))
    done
    params=("${rest[@]}")
fi


extra=()
extraBefore=()

if test -z "$NIX_LDFLAGS_SET"; then
    extra=(${extra[@]} $NIX_LDFLAGS)
    extraBefore=(${extraBefore[@]} $NIX_LDFLAGS_BEFORE)
fi


# Add all used dynamic libraries to the rpath.
if test "$NIX_DONT_SET_RPATH" != "1"; then

    # First, find all -L... switches.
    allParams=("${params[@]}" ${extra[@]})
    libPath=""
    addToLibPath() {
        local path="$1"
        if test "${path:0:1}" != "/"; then return 0; fi
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
    n=0
    while test $n -lt ${#allParams[*]}; do
        p=${allParams[n]}
        p2=${allParams[$((n+1))]}
        if test "${p:0:3}" = "-L/"; then
            addToLibPath ${p:2}
        elif test "$p" = "-L"; then
            addToLibPath ${p2}
            n=$((n + 1))
        fi
        n=$((n + 1))
    done

    # Second, for each -l... switch, find the directory containing the
    # library and add it to the rpath.
    rpath=""
    addToRPath() {
        # If the path is not in the store, don't add it to the rpath.
        # This typically happens for libraries in /tmp that are later
        # copied to $out/lib.  If not, we're screwed.
        if test "${1:0:${#NIX_STORE}}" != "$NIX_STORE"; then return 0; fi
        case $rpath in
            *\ $1\ *) return 0 ;;
        esac
        rpath="$rpath $1 "
    }
    findLib() {
        for i in $libPath; do
            if test -f $i/lib$1.so; then
                addToRPath $i
            fi
        done
    }
    n=0
    while test $n -lt ${#allParams[*]}; do
        p=${allParams[n]}
        p2=${allParams[$((n+1))]}
        if test "${p:0:2}" = "-l"; then
            findLib ${p:2}
        elif test "$p" = "-l"; then
            # I haven't seen `-l foo', but you never know...
            findLib ${p2}
            n=$((n + 1))
        fi
        n=$((n + 1))
    done

    # Finally, add `-rpath' switches.
    for i in $rpath; do
        extra=(${extra[@]} -rpath $i)
    done
fi


# Optionally print debug info.
if test "$NIX_DEBUG" = "1"; then
  echo "original flags to @ld@:" >&2
  for i in "${params[@]}"; do
      echo "  $i" >&2
  done
  echo "extra flags to @ld@:" >&2
  for i in ${extra[@]}; do
      echo "  $i" >&2
  done
fi

if test -n "$NIX_LD_WRAPPER_EXEC_HOOK"; then
    . "$NIX_LD_WRAPPER_EXEC_HOOK"
fi

exec @ld@ ${extraBefore[@]} "${params[@]}" ${extra[@]}
