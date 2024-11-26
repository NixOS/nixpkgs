{ lib, stdenv, fetchurl
, bison, readline }:

stdenv.mkDerivation {
  version = "2.2.2";
     # The current version of LiE is 2.2.2, which is more or less unchanged
     # since about the year 2000. Minor bugfixes do get applied now and then.
  pname = "lie";

  meta = {
    description = "Computer algebra package for Lie group computations";
    mainProgram = "lie";
    homepage = "http://wwwmathlabo.univ-poitiers.fr/~maavl/LiE/";
    license = lib.licenses.lgpl3; # see the website

    longDescription = ''
      LiE is a computer algebra system that is specialised in computations
      involving (reductive) Lie groups and their representations. It is
      publicly available for free in source code. For a description of its
      characteristics, we refer to the following sources of information.
    ''; # take from the website

    platforms = lib.platforms.linux;
    maintainers = [ ]; # this package is probably not going to change anyway
  };

  src = fetchurl {
    url = "http://wwwmathlabo.univ-poitiers.fr/~maavl/LiE/conLiE.tar.gz";
    sha256 = "07lbj75qqr4pq1j1qz8fyfnmrz1gnk92lnsshxycfavxl5zzdmn4";
  };

  buildInputs = [ bison readline ];

  patchPhase = ''
    substituteInPlace make_lie \
      --replace \`/bin/pwd\` $out
  '';

  installPhase = ''
    mkdir -vp $out/bin

    cp -v Lie.exe $out
    cp -v lie $out/bin

    cp -v LEARN* $out
    cp -v INFO* $out
  '';
}
