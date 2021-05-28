{ stdenv, fetchFromGitHub, fzf }:

assert stdenv.lib.asserts.assertOneOf "fzf" fzf.pname [ "fzf" "skim" ];

stdenv.mkDerivation {
  name = "kak-fzf";
  version = "2020-05-24";
  src = fetchFromGitHub {
    owner = "andreyorst";
    repo = "fzf.kak";
    rev = "b2aeb26473962ab0bf3b51ba5c81c50c1d8253d3";
    sha256 = "0bg845i814xh4y688p2zx726rsg0pd6nb4a7qv2fckmk639f4wzc";
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
