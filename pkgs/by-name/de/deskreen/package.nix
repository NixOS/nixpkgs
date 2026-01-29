{
  lib,
  stdenvNoCC,
  fetchurl,
  appimageTools,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "deskreen";
  version = "3.2.1";

  src =
    let
      sources = {
        x86_64-linux = {
          arch = "x86_64";
          hash = "sha256-yuz6F/sTWgH8YA710BxsCNTMYXUnC++f8DcefmugkvM=";
        };
        aarch64-linux = {
          arch = "arm64";
          hash = "sha256-SqbDHkXQHRbrH723ECHhyrYJcJnDG+9LawEWED6xT/k=";
        };
        # TODO more sources could be added
      };
    in
    fetchurl {
      url = "https://github.com/pavlobu/deskreen/releases/download/v${finalAttrs.version}/deskreen-ce-${finalAttrs.version}-${
        sources.${stdenvNoCC.hostPlatform.system}.arch
      }.AppImage";
      inherit (sources.${stdenvNoCC.hostPlatform.system}) hash;
    };

  deskreenUnwrapped = appimageTools.wrapType2 {
    inherit (finalAttrs) pname version src;
  };

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ln -s ${finalAttrs.deskreenUnwrapped}/bin/deskreen $out/bin/deskreen

    runHook postInstall
  '';

  meta = {
    description = "Turn any device into a secondary screen for your computer";
    homepage = "https://deskreen.com";
    license = lib.licenses.agpl3Only;
    mainProgram = "deskreen";
    maintainers = with lib.maintainers; [
      leo248
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
