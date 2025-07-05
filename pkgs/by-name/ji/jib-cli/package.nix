{
  stdenv,
  fetchurl,
  lib,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jib-cli";
  version = "0.13.0";

  src = fetchurl {
    url = "https://github.com/GoogleContainerTools/jib/releases/download/v${finalAttrs.version}-cli/jib-jre-${finalAttrs.version}.zip";
    hash = "sha256-6PakdmIh5tOBcia47hR5LEVT5WBeeaSFWPDTvvIeBGE=";
  };

  nativeBuildInputs = [ unzip ];

  dontBuild = true;

  installPhase = ''

    runHook preInstall
    install -m755 -t $out/bin bin/jib
    runHook postInstall
  '';

  meta = {
    description = "Container image builder for Java using Jib CLI";
    homepage = "https://github.com/GoogleContainerTools/jib";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      sxmair
    ];
  };
})
