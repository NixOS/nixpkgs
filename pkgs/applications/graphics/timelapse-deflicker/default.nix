{ stdenv, fetchFromGitHub, makeWrapper, perl, perlPackages }:

stdenv.mkDerivation rec {
  name = "timelapse-deflicker-${version}";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "cyberang3l";
    repo = "timelapse-deflicker";
    rev = "v${version}";
    sha256 = "0bbfnrdycrpyz7rqrql5ib9qszny7z5xpqp65c1mxqd2876gv960";
  };

  installPhase = ''
    install -m755 -D timelapse-deflicker.pl $out/bin/timelapse-deflicker
    wrapProgram $out/bin/timelapse-deflicker --set PERL5LIB $PERL5LIB
  '';

  buildInputs = with perlPackages; [
    makeWrapper perl
    PerlMagick TermProgressBar ImageExifTool
    FileType ClassMethodMaker
  ];

  meta = with stdenv.lib; {
    description = "Simple script to deflicker images taken for timelapses";
    homepage = https://github.com/cyberang3l/timelapse-deflicker;
    license = licenses.gpl3;
    maintainers = with maintainers; [ valeriangalliat ];
    platforms = platforms.unix;
  };
}
