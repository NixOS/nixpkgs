{ lib, stdenv, fetchFromGitHub }:
stdenv.mkDerivation {
  name = "kak-auto-pairs";
  version = "2020-07-14";
  src = fetchFromGitHub {
    owner = "alexherbo2";
    repo = "auto-pairs.kak";
    rev = "5b4b3b723c34c8b7f40cee60868204974349bf9f";
    sha256 = "1wgrv03f1lkzflbbaz8n23glij5rvfxf8pcqysd668mbx1hcrk9i";
  };

  installPhase = ''
    mkdir -p $out/share/kak/autoload/plugins
    cp -r rc $out/share/kak/autoload/plugins/auto-pairs
  '';

  meta = with lib;
  { description = "Kakoune extension to enable automatic closing of pairs";
    homepage = "https://github.com/alexherbo2/auto-pairs.kak";
    license = licenses.unlicense;
    maintainers = with maintainers; [ nrdxp ];
    platform = platforms.all;
  };
}
