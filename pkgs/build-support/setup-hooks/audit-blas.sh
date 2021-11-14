# shellcheck shell=bash
# Ensure that we are always linking against “libblas.so.3” and
# “liblapack.so.3”.

auditBlas() {
    local dir="$prefix"
    [ -e "$dir" ] || return 0

    local i
    while IFS= read -r -d $'\0' i; do
        if ! isELF "$i"; then continue; fi

        if $OBJDUMP -p "$i" | grep 'NEEDED' | awk '{ print $2; }' | grep -q '\(libmkl_rt.so\|libopenblas.so.0\)'; then
            echo "$i refers to a specific implementation of BLAS or LAPACK."
            echo "This prevents users from switching BLAS/LAPACK implementations."
            echo "Add \`blas' or \`lapack' to buildInputs instead of \`mkl' or \`openblas'."
            exit 1
        fi

        (IFS=:
         for dir in "$(patchelf --print-rpath "$i")"; do
             if [ -f "$dir/libblas.so.3" ] || [ -f "$dir/libblas.so" ]; then
                 if [ "$dir" != "@blas@/lib" ]; then
                     echo "$dir is not allowed to contain a library named libblas.so.3"
                     exit 1
                 fi
             fi
             if [ -f "$dir/liblapack.so.3" ] || [ -f "$dir/liblapack.so" ]; then
                 if [ "$dir" != "@lapack@/lib" ]; then
                     echo "$dir is not allowed to contain a library named liblapack.so.3"
                     exit 1
                 fi
             fi
         done)
    done < <(find "$dir" -type f -print0)
}

fixupOutputHooks+=(auditBlas)
