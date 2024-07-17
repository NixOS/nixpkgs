{
  lib,
  stdenv,
  fetchurl,
  electron,
  zstd,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "bilibili";
  version = "1.14.0-1";
  src = fetchurl {
    url = "https://github.com/msojocs/bilibili-linux/releases/download/v${version}/io.github.msojocs.bilibili_${version}_amd64.deb";
    hash = "sha256-4+DGL/DNR3wLFUff17OquAM6dOkcsXFNeCqA7ITtCaI=";
  };

  unpackPhase = ''
    runHook preUnpack

    ar x $src
    tar -I ${zstd}/bin/zstd -xvf data.tar.zst

    runHook postUnpack
  '';

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r usr/share $out/share
    sed -i "s|Exec=.*|Exec=$out/bin/bilibili|" $out/share/applications/*.desktop
    cp -r opt/apps/io.github.msojocs.bilibili/files/bin/app $out/opt
    makeWrapper ${electron}/bin/electron $out/bin/bilibili \
      --argv0 "bilibili" \
      --add-flags "$out/opt/app.asar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Electron-based bilibili desktop client";
    homepage = "https://github.com/msojocs/bilibili-linux";
    license = with licenses; [
      unfree
      mit
    ];
    maintainers = with maintainers; [
      jedsek
      kashw2
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "bilibili";
  };
}
