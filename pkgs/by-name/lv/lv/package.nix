{ lib, stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "lv";
  version = "4.51";

  src = fetchurl {
    url = "mirror://debian/pool/main/l/${pname}/${pname}_${version}.orig.tar.gz";
    sha256 = "0yf3idz1qspyff1if41xjpqqcaqa8q8icslqlnz0p9dj36gmm5l3";
  };

  makeFlags = [ "prefix=${placeholder "out"}" ];

  buildInputs = [ ncurses ];

  configurePhase = ''
    mkdir -p build
    cd build
    ../src/configure
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = with lib; {
    description = "Powerful multi-lingual file viewer / grep";
    homepage = "https://web.archive.org/web/20160310122517/www.ff.iij4u.or.jp/~nrt/lv/";
    license = licenses.gpl2Plus;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ kayhide ];
  };
}
