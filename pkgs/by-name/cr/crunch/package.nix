{
  lib,
  stdenv,
  fetchurl,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crunch";
  version = "3.6";

  src = fetchurl {
    url = "mirror://sourceforge/crunch-wordlist/crunch-${finalAttrs.version}.tgz";
    sha256 = "0mgy6ghjvzr26yrhj1bn73qzw6v9qsniskc5wqq1kk0hfhy6r3va";
  };

  nativeBuildInputs = [ which ];

  preBuild = ''
    substituteInPlace Makefile \
      --replace '-g root -o root' "" \
      --replace '-g wheel -o root' "" \
      --replace 'sudo ' ""
  '';

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "PREFIX=$(out)"
  ];

  meta = {
    description = "Wordlist generator";
    mainProgram = "crunch";
    homepage = "https://sourceforge.net/projects/crunch-wordlist/";
    platforms = lib.platforms.unix;
    license = with lib.licenses; [ gpl2Only ];
    maintainers = with lib.maintainers; [ lnl7 ];
  };
})
