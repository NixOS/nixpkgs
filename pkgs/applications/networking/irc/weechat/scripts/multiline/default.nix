{ stdenv, lib, fetchurl, substituteAll, PodParser }:

stdenv.mkDerivation {
  pname = "multiline";
  version = "0.6.3";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/weechat/scripts/945315bed4bc2beaf1e47f9b946ffe8f638f77fe/perl/multiline.pl";
    sha256 = "1smialb21ny7brhij4sbw46xvsmrdv6ig2da0ip63ga2afngwsy4";
  };

  dontUnpack = true;
  prePatch = ''
    cp $src multiline.pl
  '';

  patches = [
    # The script requires a special Perl environment.
    (substituteAll {
      src = ./libpath.patch;
      env = PodParser;
    })
  ];

  passthru.scripts = [ "multiline.pl" ];

  installPhase = ''
    runHook preInstall

    install -D multiline.pl $out/share/multiline.pl

    runHook postInstall
  '';

  meta = with lib; {
    description = "Multi-line edit box";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ oxzi ];
  };
}
