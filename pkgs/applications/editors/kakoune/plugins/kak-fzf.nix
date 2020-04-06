{ stdenv, fetchFromGitHub, fzf }:

assert stdenv.lib.asserts.assertOneOf "fzf" fzf.pname [ "fzf" "skim" ];

stdenv.mkDerivation {
  name = "kak-fzf";
  version = "2019-07-16";
  src = fetchFromGitHub {
    owner = "andreyorst";
    repo = "fzf.kak";
    rev = "ede90d3e02bceb714f997adfcbab8260b42e0a19";
    sha256 = "18w90j3fpk2ddn68497s33n66aap8phw5636y1r7pqsa641zdxcv";
  };

  configurePhase = ''
    if [[ -x "${fzf}/bin/fzf" ]]; then
      fzfImpl='${fzf}/bin/fzf'
    else
      fzfImpl='${fzf}/bin/sk'
    fi

    substituteInPlace rc/fzf.kak \
      --replace \'fzf\' \'"$fzfImpl"\'
  '';

  installPhase = ''
    mkdir -p $out/share/kak/autoload/plugins
    cp -r rc $out/share/kak/autoload/plugins/fzf
  '';

  meta = with stdenv.lib;
  { description = "Kakoune plugin that brings integration with fzf";
    homepage = "https://github.com/andreyorst/fzf.kak";
    license = licenses.mit;
    maintainers = with maintainers; [ nrdxp ];
    platform = platforms.all;
  };
}
