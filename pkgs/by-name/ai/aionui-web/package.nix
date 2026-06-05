{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  xz,
  zlib,
  gcc-unwrapped,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "aionui-web";
  version = "2.1.5";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/iOfficeAI/AionUi/releases/download/v${finalAttrs.version}/aionui-web-${finalAttrs.version}-linux-x86_64.tar.gz";
    hash = "sha256-QPNgXZhprIfYP+phIlLFsyY+PjRctOeAN7kaUAp1PQw=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    xz
    zlib
    gcc-unwrapped.lib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/aionui-web $out/bin
    cp -r ./. "$out/share/aionui-web/"
    chmod +x "$out/share/aionui-web/aionui-web"
    ln -s "$out/share/aionui-web/aionui-web" "$out/bin/aionui-web"

    runHook postInstall
  '';

  meta = {
    description = "Cowork with AI agents through a Web UI";
    homepage = "https://github.com/iOfficeAI/AionUi";
    changelog = "https://github.com/iOfficeAI/AionUi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "aionui-web";
    maintainers = with lib.maintainers; [ qrzbing ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
