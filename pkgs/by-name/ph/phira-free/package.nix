{
  lib,
  stdenvNoCC,
  phira,
  phira-unwrapped,
  imagemagick,
  ubuntu-classic,
}:

phira.override {
  overrideAssets = stdenvNoCC.mkDerivation {
    pname = "phira-assets";
    version = phira.version;

    nativeBuildInputs = [ imagemagick ];

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r ${phira-unwrapped.src}/assets $out
      chmod -R +w $out/assets

      magick -size 4000x2000 canvas:'rgb(128,162,206)' $out/assets/background.jpg
      cp ${ubuntu-classic}/share/fonts/truetype/ubuntu/Ubuntu-R.ttf $out/assets/font.ttf

      runHook postInstall
    '';
  };
}
