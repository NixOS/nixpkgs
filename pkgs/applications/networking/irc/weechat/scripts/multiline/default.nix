{ stdenv, lib, fetchurl, substituteAll, PodParser }:

stdenv.mkDerivation {
  pname = "multiline";
  version = "0.6.4";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/weechat/scripts/5f073d966e98d54344a91be4f5afc0ec9e2697dc/perl/multiline.pl";
    sha256 = "sha256-TXbU2Q7Tm8iTwOQqrWpqHXuKrjoBFLyUWRsH+TsR9Lo=";
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
