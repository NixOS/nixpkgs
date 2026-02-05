{
  lib,
  stdenv,
  requireFile,
  gogUnpackHook,
}:

let
  generic =
    ver: source:
    stdenv.mkDerivation (finalAttrs: {
      pname = "descent${toString ver}-assets";
      version = "2.0.0.7";

      src = requireFile rec {
        name = "setup_descent12_${finalAttrs.version}.exe";
        sha256 = "1r1drbfda6czg21f9qqiiwgnkpszxgmcn5bafp5ljddh34swkn3f";
        message = ''
          While the Descent ${toString ver} game engine is free, the game assets are not.

          Please purchase the game on gog.com and download the Windows installer.

          Once you have downloaded the file, please use the following command and re-run the
          installation:

          nix-prefetch-url file://\$PWD/${name}
        '';
      };

      nativeBuildInputs = [ gogUnpackHook ];

      dontBuild = true;
      dontFixup = true;

      installPhase = ''
        runHook preInstall

        mkdir -p $out/share/{games/${finalAttrs.pname},doc/${finalAttrs.pname}/examples}
        pushd "app/${source}"
        mv dosbox*.conf $out/share/doc/${finalAttrs.pname}/examples
        mv *.txt *.pdf  $out/share/doc/${finalAttrs.pname}
        cp -r * $out/share/games/descent${toString ver}
        popd

        runHook postInstall
      '';

      meta = {
        description = "Descent ${toString ver} assets from GOG";
        homepage = "https://www.dxx-rebirth.com/";
        license = lib.licenses.unfree;
        maintainers = with lib.maintainers; [ peterhoeg ];
        hydraPlatforms = [ ];
      };
    });

in
{
  descent1-assets = generic 1 "descent";
  descent2-assets = generic 2 "descent 2";
}
