# This function downloads and normalizes a patch/diff file.
# This is primarily useful for dynamically generated patches,
# such as GitHub's or cgit's, where the non-significant content parts
# often change with updating of git or cgit.
# stripLen acts as the -p parameter when applying a patch.

{ fetchurl, patchutils }:
{ stripLen ? 0, ... }@args:

fetchurl ({
  postFetch = ''
    tmpfile="$TMPDIR/${args.sha256}"
    "${patchutils}/bin/lsdiff" "$out" \
      | sort -u | sed -e 's/[*?]/\\&/g' \
      | xargs -I{} \
        "${patchutils}/bin/filterdiff" \
        --include={} \
        --strip=${toString stripLen} \
        --clean "$out" > "$tmpfile"
    mv "$tmpfile" "$out"
  '';
} // builtins.removeAttrs args ["stripLen"])
