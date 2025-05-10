{
  fetchurl,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "rime-moegirl";
  version = "20241109";
  src = fetchurl {
    url = "https://github.com/outloudvi/mw2fcitx/releases/download/20241109/moegirl.dict.yaml";
    hash = "sha256-Bnpv7iqTPRNnSiZ6ZpzcQXLZkbFbZ0nQgw2d+IyTZOQ=";
  };

  dontUnpack = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rime-data
    cp $src $out/share/rime-data/moegirl.dict.yaml

    runHook postInstall
  '';

  meta = {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "RIME dictionary file for entries from zh.moegirl.org.cn";
    homepage = "https://github.com/outloudvi/mw2fcitx/releases";
    license = lib.licenses.unlicense;
  };
}
