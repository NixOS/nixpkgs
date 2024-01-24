{ lib, fetchurl, stdenv }:

stdenv.mkDerivation {
  pname = "fcitx5-custom-pinyin-dictionary";
  version = "20240101";

  src = fetchurl {
    url = "https://github.com/wuhgit/CustomPinyinDictionary/releases/download/assets/CustomPinyinDictionary_Fcitx_20240101.tar.gz";
    hash = "sha256-8rgPHf4JvndWVUbSoOxMZAHrjRmzdGRJciplXnPCw3M=";
  };

  unpackPhase = ''
    tar -xf $src
  '';

  installPhase = ''
    mkdir -p $out/share/fcitx5/pinyin/dictionaries/
    cp CustomPinyinDictionary_Fcitx.dict $out/share/fcitx5/pinyin/dictionaries/
  '';

  meta = with lib; {
    description = "Custom Pinyin Dictionary for Fcitx. Please log out or reboot to apply the dictionary changes.";
    homepage = " https://github.com/wuhgit/CustomPinyinDictionary ";
    license = licenses.mit;
    maintainers = with maintainers; [ Wanten ];
  };
}
