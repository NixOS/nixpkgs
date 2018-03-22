# This function downloads and normalizes a patch/diff file.
# This is primarily useful for dynamically generated patches,
# such as GitHub's or cgit's, where the non-significant content parts
# often change with updating of git or cgit.
# stripLen acts as the -p parameter when applying a patch.

{ lib, fetchurl, patchutils }:
{ stripLen ? 0, extraPrefix ? null, excludes ? [], ... }@args:

fetchurl ({
  postFetch = ''
    tmpfile="$TMPDIR/${args.sha256}"
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
    ${patchutils}/bin/filterdiff \
      -p1 \
      ${builtins.toString (builtins.map (x: "-x ${x}") excludes)} \
      "$tmpfile" > "$out"
    ${args.postFetch or ""}
  '';
} // builtins.removeAttrs args ["stripLen" "extraPrefix" "excludes" "postFetch"])
