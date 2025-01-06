{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sarasa-gothic";
  version = "1.0.27";

  src = fetchurl {
    # Use the 'ttc' files here for a smaller closure size.
    # (Using 'ttf' files gives a closure size about 15x larger, as of November 2021.)
    url = "https://github.com/be5invis/Sarasa-Gothic/releases/download/v${finalAttrs.version}/Sarasa-TTC-${finalAttrs.version}.zip";
    hash = "sha256-/pN3NIwkJZ4a5g87Z3kr71Xvef0TIbN2UzsfvXJryNk=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp *.ttc $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    description = "CJK programming font based on Iosevka and Source Han Sans";
    homepage = "https://github.com/be5invis/Sarasa-Gothic";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [
      ChengCat
      wegank
    ];
    platforms = lib.platforms.all;
  };
})
