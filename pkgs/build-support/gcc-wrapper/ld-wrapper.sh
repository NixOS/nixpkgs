#! @bash@ -e

if test -n "$NIX_LD_WRAPPER_START_HOOK"; then
    . "$NIX_LD_WRAPPER_START_HOOK"
fi

. @out@/nix-support/utils


# Optionally filter out paths not refering to the store.
params=("$@")
if test "$NIX_ENFORCE_PURITY" = "1" -a -n "$NIX_STORE"; then
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

if test -z "$NIX_LDFLAGS_SET"; then
    extra=(${extra[@]} $NIX_LDFLAGS)
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

exec @ld@ "${params[@]}" ${extra[@]}
