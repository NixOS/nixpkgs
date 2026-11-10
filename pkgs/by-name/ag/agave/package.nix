{
  lib,
  fetchurl,
  stdenv,
}:

let
  pname = "agave";
  version = "39";

  mkAg =
    name: hash:
    fetchurl {
      url = "https://github.com/agarick/agave/releases/download/${version}/Agave-${name}.ttf";
      sha256 = hash;
      name = "Agave-${name}.ttf";
    };
  # There are slashed variants, but with same name so only bundle the default versions for now:
  fonts = [
    (mkAg "Regular" "sha256-tJOxMPwkj5tYFILxTMXdWfpHsQxXpVHkg0R5YeTS4vc=")
    (mkAg "Bold" "sha256-IEyT8ktU820eIwHu1k06925/QjW1FaoSjYt1oXYZgp4=")
    (mkAg "Bold-parenbulged" "sha256-m1u4TlmZKh5S5e6OVMb1jLlMf3dxrfsRBN5fJ65f0uQ=")
    (mkAg "Bold-zeroslashed" "sha256-0eBpc3+HvW2LOuVvX4HOCfTipSkOHWvu6VOVpPJgSYs=")
    (mkAg "Bold-zeroslashed-parenbulged" "sha256-yj1v8N8MeAeDp7ljBUOFgA6B7Q/qwyT4qP3gTbWJ774=")
    (mkAg "Regular-parenbulged" "sha256-WG+U7LUT+4DT8UBxKDwlYUZffHvLe3I+eMEg6BjUEAA=")
    (mkAg "Regular-zeroslashed" "sha256-YePfW8ztE6tGtgggEFiutspVbz5SZxIj+2qNzpjd2iw=")
    (mkAg "Regular-zeroslashed-parenbulged" "sha256-RqjzPh/f8wOMmNld/U2k0uebIY9e55GMsx3IUAeUd0I=")

  ];

in
stdenv.mkDerivation {
  inherit pname version;
  srcs = fonts;
  sourceRoot = ".";

  dontUnpack = true;

  installPhase = ''
    install -D $srcs -t $out/share/fonts/truetype/
  '';

  meta = {
    description = "TrueType monospaced typeface designed for X environments";
    homepage = "https://b.agaric.net/page/agave";
    license = with lib.licenses; [
      mit
      ofl
    ];
    # Change license for font files/assets to SIL Open Font License 1.1 since version 38.
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
