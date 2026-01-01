{
  lib,
  stdenv,
  fetchurl,
  weechat,
}:

stdenv.mkDerivation {
  pname = "highmon";
  version = "2.7";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/KenjiE20/highmon/182e67d070c75efc81999e68c2ac7fdfe44d2872/highmon.pl";
    sha256 = "1vvgzscb12l3cp2nq954fx6j3awvpjsb0nqylal51ps9cq9a3wir";
  };

  dontUnpack = true;

  passthru.scripts = [ "highmon.pl" ];

  installPhase = ''
    runHook preInstall

    install -D $src $out/share/highmon.pl

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    inherit (weechat.meta) platforms;
    homepage = "https://github.com/KenjiE20/highmon/";
    description = "WeeChat script that adds 'Highlight Monitor'";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ govanify ];
=======
  meta = with lib; {
    inherit (weechat.meta) platforms;
    homepage = "https://github.com/KenjiE20/highmon/";
    description = "WeeChat script that adds 'Highlight Monitor'";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ govanify ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
