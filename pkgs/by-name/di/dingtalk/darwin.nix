{
  pname,
  version,
  src,
  meta,
  stdenvNoCC,
  undmg,
  unzip,
  lib,
  xar,
  cpio,
  gzip,
  pbzx,
  xarMinimal,
}:

stdenvNoCC.mkDerivation {
  inherit
    pname
    version
    src
    meta
    ;

  nativeBuildInputs = [
    cpio
    pbzx
    undmg
    xarMinimal
  ];
  postUnpack = ''
    xar -x -f DingTalkInstaller.pkg
    pbzx -n ./DingTalk.pkg/Payload | cpio -i
  '';
  sourceRoot = ".";
  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r ./Applications/DingTalk.app $out/Applications/
    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;
}
