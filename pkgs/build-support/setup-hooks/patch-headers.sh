# This setup hook causes the fixup phase to rewrite all header
# system includes to be rewritten to absolute paths.  E.g.,
# #include <stdint.h> will be rewritten to /nix/store/<hash>-some-glibc/include/stdint.h.
# TODO: Fix absolute paths to headers for cc and libc

fixupOutputHooks+=('if [ -z "$dontPatchHeaders" ]; then patchHeaders "$prefix"; fi')

patchHeaders() {
    local dir="$1"

    # Check to see if we even have headers
    [ ! -d $dir/include ] && return 0

    header "patching header files in $dir"

    # Figure out what system header directories are available
    local extractHeaders='i{print;i=0} /-isystem/{i=1}; /-I/{print substr($0,3)}'
    local includeDirs=()
    readarray -t includeDirs <<< "$(echo "$NIX_CFLAGS_COMPILE" | \
      tr ' ' '\n' | awk "${extractHeaders}")"

    # We must include ourself as a system directory
    includeDirs+=("$dir/include")

    # Iterate over every file and replace headers
    rm -f $TMPDIR/patch-headers.awk
    for file in $(find $dir/include -type f); do
      # Build the script awk uses to fix headers
      echo '{' > $TMPDIR/patch-headers.awk
      local headerTuples
      readarray -t headerTuples <<< \
        "$(sed -n 's,.*\(#include \(<\|"\)\([^/>][^>]*\)\(>\|"\)\).*,\3 \1,p' $file)"
      for headerTuple in "${headerTuples[@]}"; do
        [ -z "$headerTuple" ] && continue
        local header="$(echo "$headerTuple" | cut -d' ' -f1)"
        local includeStmt="$(echo "$headerTuple" | cut -d' ' -f2-)"

        # If we are not doing a system include the include can
        # reside relative to the current working directory of the
        # header we are fixing.
        local canReferToPwd=0
        if echo "$includeStmt" | grep -q '#include "'; then
          canReferToPwd=1
          includeDirs+=("$(dirname "$file")")
        fi

        # Determine which include path holds the header
        # we are trying to include
        local absolute=""
        for includeDir in "${includeDirs[@]}"; do
          local tmpName="$(readlink -f "$includeDir/$header")"
          [ -f "$tmpName" ] && absolute="$tmpName"
        done

        # Unroll the includeDirs array if we added a cwd
        if [ "$canReferToPwd" -eq "1" ]; then
          includeDirs=("${includeDirs[@]:0:${#includeDirs[@]}-1}")
        fi

        # Generate the expression used for fixing the header file
        if [ -n "$absolute" ]; then
          local escapedInclude="$(echo "$includeStmt" | sed 's,/,\\/,g')"
          echo "\$0=gensub(/$escapedInclude/,\"#include \\\"$absolute\\\"\",\"g\",\$0); " \
            >> $TMPDIR/patch-headers.awk
        fi
      done
      echo 'print $0}' >> $TMPDIR/patch-headers.awk

      awk -f $TMPDIR/patch-headers.awk $file > $TMPDIR/patch-headers.out
      mv $TMPDIR/patch-headers.out $file
      rm $TMPDIR/patch-headers.awk
    done

    stopNest
}
