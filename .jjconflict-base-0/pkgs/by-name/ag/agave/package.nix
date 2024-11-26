{
  lib,
  fetchurl,
  stdenv,
}:

let
  pname = "agave";
  version = "37";

  mkAg =
    name: hash:
    fetchurl {
      url = "https://github.com/agarick/agave/releases/download/v${version}/Agave-${name}.ttf";
      sha256 = hash;
      name = "Agave-${name}.ttf";
    };
  # There are slashed variants, but with same name so only bundle the default versions for now:
  fonts = [
    (mkAg "Regular" "sha256-vX1VhEgqy9rQ7hPmAgBGxKyIs2QSAYqZC/mL/2BIOrA=")
    (mkAg "Bold" "sha256-Ax/l/RKyc03law0ThiLac/7HHV4+YxibKzcZnjZs6VI=")
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

  meta = with lib; {
    description = "truetype monospaced typeface designed for X environments";
    homepage = "https://b.agaric.net/page/agave";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
