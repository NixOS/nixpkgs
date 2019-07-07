# This function downloads and normalizes a patch/diff file.
# This is primarily useful for dynamically generated patches,
# such as GitHub's or cgit's, where the non-significant content parts
# often change with updating of git or cgit.
# stripLen acts as the -p parameter when applying a patch.

{ lib, fetchurl, buildPackages }:
let
  # 0.3.4 would change hashes: https://github.com/NixOS/nixpkgs/issues/25154
  patchutils = buildPackages.patchutils_0_3_3;
in
{ stripLen ? 0, extraPrefix ? null, excludes ? [], includes ? [], revert ? false, ... }@args:

fetchurl ({
  postFetch = ''
    tmpfile="$TMPDIR/${args.sha256}"
    if [ ! -s "$out" ]; then
      echo "error: Fetched patch file '$out' is empty!" 1>&2
      exit 1
    fi
    "${patchutils}/bin/lsdiff" "$out" \
      | sort -u | sed -e 's/[*?]/\\&/g' \
      | xargs -I{} \
        "${patchutils}/bin/filterdiff" \
        --include={} \
        --strip=${toString stripLen} \
        ${lib.optionalString (extraPrefix != null) ''
           --addoldprefix=a/${extraPrefix} \
           --addnewprefix=b/${extraPrefix} \
        ''} \
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
      echo "error: Filtered patch '$out$' is empty (while the original patch file was not)!" 1>&2
      echo "Check your includes and excludes." 1>&2
      echo "Normalizd patch file was:" 1>&2
      cat "$tmpfile" 1>&2
      exit 1
    fi
  '' + lib.optionalString revert ''
    ${patchutils}/bin/interdiff "$out" /dev/null > "$tmpfile"
    mv "$tmpfile" "$out"
  '' + (args.postFetch or "");
  meta.broken = excludes != [] && includes != [];
} // builtins.removeAttrs args ["stripLen" "extraPrefix" "excludes" "includes" "revert" "postFetch"])
