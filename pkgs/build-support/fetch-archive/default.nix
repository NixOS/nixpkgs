{ stdenv, fetchurl }: { url, hash, inputs ? [] }:

(fetchurl {
  inherit url;

  name = "source";
  outputHash = hash;

  downloadToTemp = true;
  recursiveHash = true;

  postFetch = ''
    mkdir "$out"
    cd "$out"

    in="$TMPDIR/${baseNameOf url}"
    mv "$downloadedFile" "$in"
    unpackFile "$in"

    chmod -R ugo-w "$out"
  '';
}).overrideAttrs (super: {
  nativeBuildInputs = super.nativeBuildInputs ++ inputs;
})
