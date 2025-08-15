{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  perl,
  inkscape,
  librsvg,
  targets ? [ "all" ],
}:

stdenvNoCC.mkDerivation {
  pname = "iso-flags";
  version = "0-unstable-2020-01-18";

  src = fetchFromGitHub {
    owner = "joielechong";
    repo = "iso-country-flags-svg-collection";
    rev = "9ebbd577b9a70fbfd9a1931be80c66e0d2f31a9d";
    hash = "sha256-tHXfksKmvnoziSkONMbsG0bTRt7nbtcj992UVgk/dZ0=";
  };

  nativeBuildInputs = [
    perl
    inkscape
    librsvg
    (perl.withPackages (
      pp: with pp; [
        JSON
        XMLLibXML
      ]
    ))
  ];

  postPatch = ''
    patchShebangs .
  '';

  buildFlags = targets;

  installPhase = ''
    mkdir -p $out/share
    mv build $out/share/iso-flags
  '';

  meta = {
    homepage = "https://github.com/joielechong/iso-country-flags-svg-collection";
    description = "248 country flag SVG & PNG icons with different icon styles";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.linux; # the output assets should work anywhere, but unsure about the tools to build them...
    maintainers = with lib.maintainers; [ mkg20001 ];
  };
}
