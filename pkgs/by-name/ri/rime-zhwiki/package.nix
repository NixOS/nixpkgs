{
  fetchurl,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "rime-zhwiki";
  version = "20250823";
  src = fetchurl {
    url = "https://github.com/felixonmars/fcitx5-pinyin-zhwiki/releases/download/0.2.5/zhwiki-20250823.dict.yaml";
    hash = "sha256-on8oYS/5K24R1wWhsz276B6hA7rHVd124uFHx2Ent70=";
  };

  dontUnpack = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/rime-data
    cp $src $out/share/rime-data/zhwiki.dict.yaml

    runHook postInstall
  '';

  meta = {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "RIME dictionary file for entries from zh.wikipedia.org";
    homepage = "https://github.com/felixonmars/fcitx5-pinyin-zhwiki";
    license = [
      lib.licenses.fdl13Plus
      lib.licenses.cc-by-sa-40
    ];
  };
}
