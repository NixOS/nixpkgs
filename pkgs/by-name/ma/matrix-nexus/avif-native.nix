{
  stdenv,
  libavif,
  jq,
}:
{ version, src, ... }:
stdenv.mkDerivation {
  pname = "avif_native";
  inherit version src;
  inherit (src) passthru;

  nativeBuildInputs = [ jq ];
  buildInputs = [ libavif ];

  buildPhase = ''
    $CC -shared -fPIC src/avif_shim.c -lavif -o native/libavif_native.so
  '';

  # The hook checksums the library, so it mustn't change after it's hashed
  dontFixup = true;

  # Nexus only decodes, with dav1d, see hooks.user_defines in pubspec.yaml
  installPhase = ''
    cp -r . $out
    jq --arg hash "$(sha256sum native/libavif_native.so | cut -d " " -f 1)" \
      '.artifacts |= with_entries(
        if .key | test("^linux-.*-decode-dav1d$")
        then .value += { path: "libavif_native.so", librarySha256: $hash }
        else . end
      )' native/manifest.json > $out/native/manifest.json
  '';
}
