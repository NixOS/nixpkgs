{
  lib,
  stdenv,
  fetchurl,
  electron_30,
  dpkg,
  makeWrapper,
  commandLineArgs ? "",
}:
let
  version = "1.14.0-2";
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/msojocs/bilibili-linux/releases/download/v${version}/io.github.msojocs.bilibili_${version}_amd64.deb";
      hash = "sha256-QQMdEpKE7r/fPMaX/yEoaa7KjilhiPMYLRvGPkv1jds=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/msojocs/bilibili-linux/releases/download/v${version}/io.github.msojocs.bilibili_${version}_arm64.deb";
      hash = "sha256-UaGI4BLhfoYluZpARsj+I0iEmFXYYNfl4JWhBWOOip0=";
    };
  };
  src =
    srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "bilibili";
  inherit src version;
  unpackPhase = ''
    runHook preUnpack
    dpkg -x $src ./
    runHook postUnpack
  '';

  nativeBuildInputs = [
    makeWrapper
    dpkg
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r usr/share $out/share
    sed -i "s|Exec=.*|Exec=$out/bin/bilibili|" $out/share/applications/*.desktop
    cp -r opt/apps/io.github.msojocs.bilibili/files/bin/app $out/opt
    makeWrapper ${lib.getExe electron_30} $out/bin/bilibili \
      --argv0 "bilibili" \
      --add-flags "$out/opt/app.asar" \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    runHook postInstall
  '';

  meta = {
    description = "Electron-based bilibili desktop client";
    homepage = "https://github.com/msojocs/bilibili-linux";
    license = with lib.licenses; [
      unfree
      mit
    ];
    maintainers = with lib.maintainers; [
      jedsek
      kashw2
      bot-wxt1221
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "bilibili";
  };
}
