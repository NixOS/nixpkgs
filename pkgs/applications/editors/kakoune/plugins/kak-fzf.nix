{ stdenv, fetchFromGitHub, fzf }:

assert stdenv.lib.asserts.assertOneOf "fzf" fzf.pname [ "fzf" "skim" ];

stdenv.mkDerivation {
  name = "kak-fzf";
  version = "2020-07-26";

  src = fetchFromGitHub {
    owner = "andreyorst";
    repo = "fzf.kak";
    rev = "f23daa698ad95493fbd675ae153e3cac13ef34e9";
    hash = "sha256-BfXHTJ371ThOizMI/4BAbdJoaltGSP586hz4HqX1KWA=";
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
