{
  lib,
  stdenvNoCC,
  fetchurl,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "softnet";
  version = "0.21.1";

  src = fetchurl {
    url = "https://github.com/openai/softnet/releases/download/${finalAttrs.version}/softnet.tar.gz";
    hash = "sha256-vhxz1Hxbn/26Ie++Zbi2QLnUYlCt5YisSVDbziQRq6Y=";
  };
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -D softnet $out/bin/softnet
    install -Dm444 -t $out/share/softnet README.md LICENSE

    runHook postInstall
  '';

  meta = {
    description = "Software networking with isolation for Tart";
    homepage = "https://github.com/openai/softnet";
    license = lib.licenses.fsl11Asl20;
    maintainers = with lib.maintainers; [ emilytrau ];
    platforms = [ "aarch64-darwin" ];
    # Source build will be possible after darwin SDK 12.0 bump
    # https://github.com/NixOS/nixpkgs/pull/229210
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
