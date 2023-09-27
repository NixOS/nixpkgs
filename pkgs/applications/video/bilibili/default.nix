{ lib
, stdenv
, fetchurl
, electron
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "bilibili";
  version = "1.12.0-2";
  src = fetchurl {
    url = "https://github.com/msojocs/bilibili-linux/releases/download/v${version}/io.github.msojocs.bilibili_${version}_amd64.deb";
    hash = "sha256-LnTRznIUXU7h0SyOCfVjfqhNv2OCRujNoM1PtGUVJeU=";
  };

  unpackPhase = ''
    runHook preUnpack

    ar x $src
    tar xf data.tar.xz

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
    license = licenses.mit;
    maintainers = with maintainers; [ jedsek kashw2 ];
    platforms = platforms.unix;
  };
}
