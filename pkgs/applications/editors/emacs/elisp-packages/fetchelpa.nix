# Elpa only serves the latest version of a given package uncompressed.
# Once that release is no longer the latest & greatest it gets archived and compressed
# meaning that both the URL and the hash changes.
#
# To work around this issue we fall back to the URL with the .lz suffix and if that's the
# one we downloaded we uncompress the file to ensure the hash matches regardless of compression.

{ fetchurl, lzip }:

{ url, ... }@args: fetchurl ((removeAttrs args [ "url" ]) // {
  urls = [
    url
    (url + ".lz")
  ];
  postFetch = ''
    if [[ $url == *.lz ]]; then
      ${lzip}/bin/lzip -c -d $out > uncompressed
      mv uncompressed $out
    fi
  '';
})
