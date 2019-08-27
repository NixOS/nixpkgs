{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation {
  name = "kak-fzf";
  version = "2019-07-16";
  src = fetchFromGitHub {
    owner = "andreyorst";
    repo = "fzf.kak";
    rev = "ede90d3e02bceb714f997adfcbab8260b42e0a19";
    sha256 = "18w90j3fpk2ddn68497s33n66aap8phw5636y1r7pqsa641zdxcv";
  };

  installPhase = ''
    mkdir -p $out/share/kak/autoload/plugins
    cp -r rc $out/share/kak/autoload/plugins/fzf
  '';

  meta = with stdenv.lib;
  { description = "Kakoune plugin that brings integration with fzf";
    homepage = "https://github.com/andreyorst/fzf.kak";
    license = licenses.publicDoman;
    maintainers = with maintainers; [ nrdxp ];
    platform = platforms.all;
  };
}
