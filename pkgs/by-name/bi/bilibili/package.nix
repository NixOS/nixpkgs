{
  lib,
  stdenv,
  fetchurl,
  electron,
  dpkg,
  makeWrapper,
  commandLineArgs ? "",
}:
let
  sources = import ./sources.nix;
  version = sources.version;
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/msojocs/bilibili-linux/releases/download/v${version}/io.github.msojocs.bilibili_${version}_amd64.deb";
      hash = sources.x86_64-hash;
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/msojocs/bilibili-linux/releases/download/v${version}/io.github.msojocs.bilibili_${version}_arm64.deb";
      hash = sources.arm64-hash;
    };
  };
  src =
    srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "bilibili";
  inherit src version;

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
    makeWrapper ${lib.getExe electron} $out/bin/bilibili \
      --argv0 "bilibili" \
      --add-flags "$out/opt/app.asar" \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

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
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "bilibili";
  };
}
