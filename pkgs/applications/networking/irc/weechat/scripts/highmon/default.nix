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
    hash = "sha256-OfKhEmZJ31Cooh5bsLS8m6shTXekJGzFZYOKsJj+b+8=";
  };

  dontUnpack = true;

  passthru.scripts = [ "highmon.pl" ];

  installPhase = ''
    runHook preInstall

    install -D $src $out/share/highmon.pl

    runHook postInstall
  '';

  meta = {
    inherit (weechat.meta) platforms;
    homepage = "https://github.com/KenjiE20/highmon/";
    description = "WeeChat script that adds 'Highlight Monitor'";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ govanify ];
  };
}
