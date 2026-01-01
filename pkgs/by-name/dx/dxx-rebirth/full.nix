{
  lib,
  stdenv,
  makeWrapper,
  dxx-rebirth,
  descent1-assets,
  descent2-assets,
}:

let
  generic =
    ver: assets:
    stdenv.mkDerivation {
      name = "d${toString ver}x-rebirth-full-${assets.version}";

      nativeBuildInputs = [ makeWrapper ];

      buildCommand = ''
        mkdir -p $out/bin

        makeWrapper ${dxx-rebirth}/bin/d${toString ver}x-rebirth $out/bin/descent${toString ver} \
          --add-flags "-hogdir ${assets}/share/games/descent${toString ver}"
      '';

<<<<<<< HEAD
      meta = {
        description = "Descent ${toString ver} using the DXX-Rebirth project engine and game assets from GOG";
        homepage = "https://www.dxx-rebirth.com/";
        license = with lib.licenses; [
          free
          unfree
        ];
        maintainers = with lib.maintainers; [ peterhoeg ];
        platforms = with lib.platforms; linux;
=======
      meta = with lib; {
        description = "Descent ${toString ver} using the DXX-Rebirth project engine and game assets from GOG";
        homepage = "https://www.dxx-rebirth.com/";
        license = with licenses; [
          free
          unfree
        ];
        maintainers = with maintainers; [ peterhoeg ];
        platforms = with platforms; linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
        hydraPlatforms = [ ];
      };
    };

in
{
  d1x-rebirth-full = generic 1 descent1-assets;
  d2x-rebirth-full = generic 2 descent2-assets;
}
