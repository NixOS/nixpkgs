# This function downloads and normalizes a patch/diff file.
# This is primarily useful for dynamically generated patches,
# such as GitHub's or cgit's, where the non-significant content parts
# often change with updating of git or cgit.
# stripLen acts as the -p parameter when applying a patch.

{
  lib,
  fetchurl,
  patchutils,
}:

{
  relative ? null,
  stripLen ? 0,
  decode ? "cat", # custom command to decode patch e.g. base64 -d
  extraPrefix ? null,
  excludes ? [ ],
  includes ? [ ],
  revert ? false,
  postFetch ? "",
  ...
}@args:
let
  args' =
    if relative != null then
      {
        stripLen = 1 + lib.length (lib.splitString "/" relative) + stripLen;
        extraPrefix = lib.optionalString (extraPrefix != null) extraPrefix;
      }
    else
      {
        inherit stripLen extraPrefix;
      };
in
let
  inherit (args') stripLen extraPrefix;
in
lib.throwIfNot (excludes == [ ] || includes == [ ])
  "fetchpatch: cannot use excludes and includes simultaneously"
  fetchurl
  (
    {
      postFetch =
        ''
          tmpfile="$TMPDIR/patch"

          if [ ! -s "$out" ]; then
            echo "error: Fetched patch file '$out' is empty!" 1>&2
            exit 1
          fi

          set +e
          ${decode} < "$out" > "$tmpfile"
          if [ $? -ne 0 ] || [ ! -s "$tmpfile" ]; then
              echo 'Failed to decode patch with command "'${lib.escapeShellArg decode}'"' >&2
              echo 'Fetched file was (limited to 128 bytes):' >&2
              od -A x -t x1z -v -N 128 "$out" >&2
              exit 1
          fi
          set -e
          mv "$tmpfile" "$out"

          "${patchutils}/bin/lsdiff" \
            ${lib.optionalString (relative != null) "-p1 -i ${lib.escapeShellArg relative}/'*'"} \
            "$out" \
          | sort -u | sed -e 's/[*?]/\\&/g' \
          | xargs -I{} \
            "${patchutils}/bin/filterdiff" \
            --include={} \
            --strip=${toString stripLen} \
            ${
              lib.optionalString (extraPrefix != null) ''
                --addoldprefix=a/${lib.escapeShellArg extraPrefix} \
                --addnewprefix=b/${lib.escapeShellArg extraPrefix} \
              ''
            } \
            --clean "$out" > "$tmpfile"

          if [ ! -s "$tmpfile" ]; then
            echo "error: Normalized patch '$tmpfile' is empty (while the fetched file was not)!" 1>&2
            echo "Did you maybe fetch a HTML representation of a patch instead of a raw patch?" 1>&2
            echo "Fetched file was:" 1>&2
            cat "$out" 1>&2
            exit 1
          fi

          ${patchutils}/bin/filterdiff \
            -p1 \
            ${builtins.toString (builtins.map (x: "-x ${lib.escapeShellArg x}") excludes)} \
            ${builtins.toString (builtins.map (x: "-i ${lib.escapeShellArg x}") includes)} \
            "$tmpfile" > "$out"

          if [ ! -s "$out" ]; then
            echo "error: Filtered patch '$out' is empty (while the original patch file was not)!" 1>&2
            echo "Check your includes and excludes." 1>&2
            echo "Normalized patch file was:" 1>&2
            cat "$tmpfile" 1>&2
            exit 1
          fi
        ''
        + lib.optionalString revert ''
          ${patchutils}/bin/interdiff "$out" /dev/null > "$tmpfile"
          mv "$tmpfile" "$out"
        ''
        + postFetch;
    }
    // builtins.removeAttrs args [
      "relative"
      "stripLen"
      "decode"
      "extraPrefix"
      "excludes"
      "includes"
      "revert"
      "postFetch"
    ]
  )
