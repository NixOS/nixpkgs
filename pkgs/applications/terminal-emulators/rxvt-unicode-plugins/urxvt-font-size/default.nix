{ lib, stdenv, fetchFromGitHub, xrdb, xlsfonts }:

stdenv.mkDerivation rec {
  pname = "urxvt-font-size";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "majutsushi";
    repo = "urxvt-font-size";
    rev = "v${version}";
    sha256 = "1526ap161cp3378f4ijd09nmsh71ld7bkxxhp8p6razdi2v8r16h";
  };

  installPhase = ''
    substituteInPlace font-size \
      --replace "xrdb -merge" "${xrdb}/bin/xrdb -merge" \
      --replace "xlsfonts" "${xlsfonts}/bin/xlsfonts"

    mkdir -p $out/lib/urxvt/perl
    cp font-size $out/lib/urxvt/perl
  '';

  meta = with lib; {
    description = "Change the urxvt font size on the fly";
    homepage = "https://github.com/majutsushi/urxvt-font-size";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = with platforms; unix;
  };
}
