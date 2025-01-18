{
  stdenv,
  lib,
  callPackage,
}:
let
  src = (callPackage ./sources.nix { }).stable;
in
stdenv.mkDerivation {
  pname = "wine-fonts";
  inherit (src) version;

  sourceRoot = "wine-${src.version}/fonts";
  inherit src;

  installPhase = ''
    install *.ttf -Dt $out/share/fonts/wine
  '';

  meta = with lib; {
    description = "Microsoft replacement fonts by the Wine project";
    homepage = "https://wiki.winehq.org/Create_Fonts";
    license = with licenses; [ lgpl21Plus ];
    platforms = platforms.all;
    maintainers = with maintainers; [
      avnik
      raskin
      bendlas
      johnazoidberg
    ];
  };
}
