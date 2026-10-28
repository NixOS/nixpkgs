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

  src = fetchurl {
    url = "https://hamrs-releases.s3.us-east-2.amazonaws.com/${finalAttrs.version}/HAMRS-${finalAttrs.version}.dmg";
    hash = "sha256-IQ7r2OLwJW4auiNDddzZ99jXxrtPw3uYoGIUEHU1gtc=";
  };

  nativeBuildInputs = [ _7zz ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  inherit meta;
})
