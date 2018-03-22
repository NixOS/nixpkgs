{ stdenv, fetchFromGitHub, xrdb, xlsfonts }:

stdenv.mkDerivation {
  name = "urxvt-font-size-2015-05-22";
  dontPatchShebangs = true;

  src = fetchFromGitHub {
    owner = "majutsushi";
    repo = "urxvt-font-size";
    rev = "fd5b09c10798c6723bbf771d4d8881cf6563bc69";
    sha256 = "16m3kkypg3y00x597zx05zy167a0kaqpawz0l591wzb2bv1dz55z";
  };

  installPhase = ''
    substituteInPlace font-size \
      --replace "xrdb -merge" "${xrdb}/bin/xrdb -merge" \
      --replace "xlsfonts" "${xlsfonts}/bin/xlsfonts"

    mkdir -p $out/lib/urxvt/perl
    cp font-size $out/lib/urxvt/perl
  '';

  meta = with stdenv.lib; {
    description = "Change the urxvt font size on the fly";
    homepage = https://github.com/majutsushi/urxvt-font-size;
    license = licenses.mit;
    maintainers = with maintainers; [ cstrahan ];
    platforms = with platforms; unix;
  };
}
