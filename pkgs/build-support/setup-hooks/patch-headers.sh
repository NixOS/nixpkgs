# This setup hook causes the fixup phase to rewrite all header
# system includes to be rewritten to absolute paths.  E.g.,
# #include <stdint.h> will be rewritten to /nix/store/<hash>-some-glibc/include/stdint.h.

fixupOutputHooks+=('if [ -z "$dontPatchHeaders" ]; then patchHeaders "$prefix"; fi')

patchHeaders() {
    local dir="$1"

    # Check to see if we even have headers
    [ ! -d $dir/include ] && return 0

    header "patching header files in $dir"

    # HACK: Fix gcc header linking by using the new cpp binary
    # This prevents us from linking to bootstrap tools in new stdenvs
    local cpp=cpp
    local output
    for output in $outputs; do
      if ${!output}/bin/cpp --help >/dev/null 2>&1; then
        cpp=${!output}/bin/cpp
        break
      fi
    done

    # Iterate over every file and replace headers
    rm -f $TMPDIR/patch-headers.awk
    local file
    for file in $(find $dir/include -type f); do
      # Determine what paths to search for includes
      # CPP is the most reliable way to parse the environment as
      # it gives us system and libc includes as well.
      local rawCpp="$($cpp -v -M $NIX_CFLAGS_COMPILE $file 2>&1)"
      if [ "$?" -ne "0" ]; then
        echo "Failed to process: $file" >&2
        continue
      fi

      # Parse the cpp output into useful header location lists
      local cppSystemIncludes="$(echo "$rawCpp" | awk '/End/{f=0};f{print $1};/#include </{f=1};')"
      local tmpComb="$dir/include"$'\n'"$cppSystemIncludes"
      local systemIncludes="$(echo "$tmpComb" | grep -v '^[ \r]*$')"

      local cppLocalIncludes="$(echo "$rawCpp" | awk '/#include </{f=0};f{print $1};/#include "/{f=1};')"
      local tmpComb="$(dirname "$file")"$'\n'"$cppLocalIncludes"$'\n'"$systemIncludes"
      local localIncludes="$(echo "$tmpComb" | grep -v '^[ \r]*$')"

      local headerPath="$(readlink -f "$(dirname "$file")")"
      local nextIncludes="$(for includeDir in $localIncludes; do
        [ "$(readlink -f "$includeDir")" != "$headerPath" ] && echo "$includeDir"; done)"

      # Build the script awk uses to fix headers
      echo '{' > $TMPDIR/patch-headers.awk

      # There are multiple types of includes we need to consider
      # #include "" which uses local paths
      # #include <> which is system paths only
      # #include_next [<"][>"] which looks only at the next paths in the list
      # include_next in this context would effectively exclude any cwd
      local headerTuples
      readarray -t headerTuples <<< \
        "$(sed -n 's;.*\(#[ ]*include\(_next\)\{0,1\}[ ]*\(<\|"\)\([^/>][^>]*\)\(>\|"\)\).*;\4 \1;p' $file)"

      # Determine where each of the includes resides and build an expression to patch it
      local headerTuple
      for headerTuple in "${headerTuples[@]}"; do
        [ -z "$headerTuple" ] && continue
        local header="$(echo "$headerTuple" | cut -d' ' -f1)"
        local includeStmt="$(echo "$headerTuple" | cut -d' ' -f2-)"

        # HACK: Prevent cyclic references to compiler defined headers
        # which bring in dependencies like bootstrap-tools.
        # These headers are guaranteed to exist.
        grep -q '^\(stddef.h\|stdarg.h\|limits.h\|float.h\)$' <<< "$header" && continue

        # Determine directory list based on the type of include
        if echo "$includeStmt" | grep -q '_next'; then
          local includeDirs="$nextIncludes"
        elif echo "$includeStmt" | grep -q '"'; then
          local includeDirs="$localIncludes"
        else
          local includeDirs="$systemIncludes"
        fi

        # Determine which include path holds the header
        # we are trying to include
        local absolute=""
        local includeDir
        for includeDir in $includeDirs; do
          local tmpName="$(readlink -f "$includeDir/$header")"
          if [ -f "$tmpName" ]; then
            absolute="$tmpName"
            break
          fi
        done

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
