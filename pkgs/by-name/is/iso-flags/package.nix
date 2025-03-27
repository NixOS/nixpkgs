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
  version = "unstable-18012020";

  src = fetchFromGitHub {
    owner = "joielechong";
    repo = "iso-country-flags-svg-collection";
    rev = "9ebbd577b9a70fbfd9a1931be80c66e0d2f31a9d";
    sha256 = "17bm7w4md56xywixfvp7vr3d6ihvxk3383i9i4rpmgm6qa9dyxdl";
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

  meta = with lib; {
    homepage = "https://github.com/joielechong/iso-country-flags-svg-collection";
    description = "248 country flag SVG & PNG icons with different icon styles";
    license = [ licenses.publicDomain ];
    platforms = platforms.linux; # the output assets should work anywhere, but unsure about the tools to build them...
    maintainers = [ maintainers.mkg20001 ];
  };
}
