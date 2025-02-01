{ lib
, stdenv
, fetchFromGitHub
, openssl
, iconv
, makeWrapper
, imagemagick
, makeFontsConf
}:
stdenv.mkDerivation
{
  pname = "sgfutils";
  version = "0.25-unstable-2017-11-27";
  src = fetchFromGitHub {
    owner = "yangboz";
    repo = "sgfutils";
    rev = "11ab171c46cc16cc71ac6fc901d38ea88d6532a4";
    hash = "sha256-KWYgTxz32WK3MKouj1WAJtZmleKt5giCpzQPwfWruZQ=";
  };
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ iconv ];
  buildPhase = ''
    runHook preBuild
    make all
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp sgf sgfsplit sgfvarsplit sgfstrip sgfinfo sgfmerge sgftf \
      sgfcheck sgfdb sgfdbinfo sgfcharset sgfcmp sgfx \
      ngf2sgf nip2sgf nk2sgf gib2sgf sgftopng ugi2sgf \
      $out/bin
    runHook postInstall
  '';
  postFixup = ''
    wrapProgram $out/bin/sgftopng \
      --prefix PATH : ${lib.makeBinPath [ imagemagick ]} \
      --set-default FONTCONFIG_FILE ${makeFontsConf { fontDirectories = []; }}
  '';
  meta = with lib; {
    homepage = "https://homepages.cwi.nl/~aeb/go/sgfutils/html/sgfutils.html";
    description = "Command line utilities that help working with SGF files";
    longDescription = ''
      The package sgfutils is a collection of command line utilities that help working with SGF files,
      especially when they describe go (igo, weiqi, baduk) games.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ggpeti ];
    platforms = platforms.all; # tested on x86_64-linux and aarch64-darwin
  };
}
