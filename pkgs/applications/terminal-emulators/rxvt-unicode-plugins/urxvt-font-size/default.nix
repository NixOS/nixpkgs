{
  lib,
  stdenv,
  fetchFromGitHub,
  xrdb,
  xlsfonts,
}:

stdenv.mkDerivation rec {
  pname = "urxvt-font-size";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "majutsushi";
    repo = "urxvt-font-size";
    rev = "v${version}";
    hash = "sha256-0ISMtojtq2wuurD3uU6j4UBdbQJNRuLQGeOyYMJVRpQ=";
  };

  installPhase = ''
    substituteInPlace font-size \
      --replace "xrdb -merge" "${xrdb}/bin/xrdb -merge" \
      --replace "xlsfonts" "${xlsfonts}/bin/xlsfonts"

    mkdir -p $out/lib/urxvt/perl
    cp font-size $out/lib/urxvt/perl
  '';

  meta = {
    description = "Change the urxvt font size on the fly";
    homepage = "https://github.com/majutsushi/urxvt-font-size";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = with lib.platforms; unix;
  };
}
