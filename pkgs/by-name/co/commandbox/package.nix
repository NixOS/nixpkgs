{ lib
, stdenvNoCC
, fetchzip
, makeWrapper
, jdk11_headless
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname   = "commandbox";
  version = "6.2.1";

  src = fetchzip {
    url = "https://downloads.ortussolutions.com/ortussolutions/commandbox/${finalAttrs.version}/commandbox-bin-${finalAttrs.version}.zip";
    hash = "sha256-2+KvhdKhP2u1YqLN28AA2n4cdPQp4wgaOrpgqS7JFp8=";
    stripRoot = false;
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 box $out/bin/box

    runHook postInstall
  '';

  meta =  {
    description = "CommandBox CFML CLI, package manager, and embedded CFML server";
    homepage    = "https://www.ortussolutions.com/products/commandbox";
    license     = lib.licenses.asl20;
    platforms   = lib.platforms.linux;
    mainProgram = "box";
    maintainers = [ ];
  };
})
