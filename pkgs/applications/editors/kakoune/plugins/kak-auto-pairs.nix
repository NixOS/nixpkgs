{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation {
  name = "kak-auto-pairs";
  version = "2019-07-27";
  src = fetchFromGitHub {
    owner = "alexherbo2";
    repo = "auto-pairs.kak";
    rev = "886449b1a04d43e5deb2f0ef4b1aead6084c7a5f";
    sha256 = "0knfhdvslzw1f1r1k16733yhkczrg3yijjz6n2qwira84iv3239j";
  };

  installPhase = ''
    mkdir -p $out/share/kak/autoload/plugins
    cp -r rc $out/share/kak/autoload/plugins/auto-pairs
  '';

  meta = with stdenv.lib;
  { description = "Kakoune extension to enable automatic closing of pairs";
    homepage = "https://github.com/alexherbo2/auto-pairs.kak";
    license = licenses.unlicense;
    maintainers = with maintainers; [ nrdxp ];
    platform = platforms.all;
  };
}
