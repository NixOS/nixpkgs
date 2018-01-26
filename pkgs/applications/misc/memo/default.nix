{ fetchFromGitHub, ack , tree, stdenv, ... }:

stdenv.mkDerivation rec {

  name = "memo-${version}";

  version = "0.2";

  src = fetchFromGitHub {
    owner  = "mrVanDalo";
    repo   = "memo";
    rev    = "${version}";
    sha256 = "0mww4w5m6jv4s0krm74cccrz0vlr8rrwiv122jk67l1v9r80pchs";
  };

  installPhase = ''
    mkdir -p $out/{bin,share/man/man1,share/bash-completion/completions}
    mv memo $out/bin/
    mv doc/memo.1 $out/share/man/man1/memo.1
    mv completion/memo.bash $out/share/bash-completion/completions/memo.sh
  '';

  meta = {
    description = "A simple tool written in bash to memorize stuff";
    longDescription = ''
      A simple tool written in bash to memorize stuff.
      Memo organizes is structured through topics which are folders in ~/memo.
    '';
    homepage = http://palovandalo.com/memo/;
    downloadPage = https://github.com/mrVanDalo/memo/releases;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.mrVanDalo ];
    platforms = stdenv.lib.platforms.all;
  };
}