{ fetchFromGitHub, ag, tree, man, stdenv, 
  pandocSupport ? true, pandoc ? null
  , ... }:

assert pandocSupport -> pandoc != null;

stdenv.mkDerivation rec {

  name = "memo-${version}";

  version = "0.4";

  src = fetchFromGitHub {
    owner  = "mrVanDalo";
    repo   = "memo";
    rev    = "${version}";
    sha256 = "06999nps46dxrjakvpin1d2zvfpjil69hb3bxagq29icalag3y2z";
  };

  installPhase = let
    pandocReplacement = if pandocSupport then
      "pandoc_cmd=${pandoc}/bin/pandoc"
    else
      "#pandoc_cmd=pandoc";
  in ''
    mkdir -p $out/{bin,share/man/man1,share/bash-completion/completions}
    substituteInPlace memo \
      --replace "ack_cmd=ack"       "ack_cmd=${ag}/bin/ag" \
      --replace "tree_cmd=tree"     "tree_cmd=${tree}/bin/tree" \
      --replace "man_cmd=man"       "man_cmd=${man}/bin/man" \
      --replace "pandoc_cmd=pandoc" "${pandocReplacement}"
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
