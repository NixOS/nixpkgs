{
  lib,
  stdenvNoCC,
  pname,
  version,
  meta,
  fetchurl,
  _7zz,
  undmg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version;

  src =
    if stdenvNoCC.hostPlatform.isAarch64 then
      (fetchurl {
        url = "https://hamrs-releases.s3.us-east-2.amazonaws.com/${finalAttrs.version}/HAMRS-${finalAttrs.version}.dmg";
        hash = "sha256-IQ7r2OLwJW4auiNDddzZ99jXxrtPw3uYoGIUEHU1gtc=";
      })
    else
      (fetchurl {
        url = "https://hamrs-releases.s3.us-east-2.amazonaws.com/${finalAttrs.version}/HAMRS-${finalAttrs.version}-intel.dmg";
        hash = "sha256-bgWeIARE3gO5FA9MqidfXo1Wdn5wDUa/RNzZBxSKloM=";
      });

  nativeBuildInputs = if stdenvNoCC.hostPlatform.isAarch64 then [ _7zz ] else [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  inherit meta;
})
