{
  lib,
  stdenv,
  fetchzip,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "qb-web";
  version = "nightly-20230513";

  src = fetchzip {
    url = "https://github.com/CzBiX/qb-web/releases/download/nightly-20230513/qb-web-nightly-20230513.zip";
    sha256 = "sha256-fcH1K0aaCRQivcza3RKuoTo5Mjqi3Kgmt++CHkrneH0=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/qb-web
    cp -r . $out/share/qb-web
    echo "${finalAttrs.version}" > $out/share/qb-web/version.txt

    runHook postInstall
  '';

  meta = {
    description = "A qBittorrent Web UI, written in TypeScript + Vue.js";
    homepage = "https://github.com/CzBiX/qb-web";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ valyntyler ];
  };
})
