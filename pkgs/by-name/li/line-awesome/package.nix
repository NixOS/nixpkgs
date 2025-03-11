{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation rec {
  pname = "line-awesome";
  version = "1.3.0";

  src = fetchurl {
    url = "https://maxst.icons8.com/vue-static/landings/line-awesome/line-awesome/${version}/line-awesome-${version}.zip";
    sha256 = "07qkz8s1wjh5xwqlq1b4lpihr1zah3kh6bnqvfwvncld8l9wjqfk";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = "${version}/fonts";

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    mkdir -p $out/share/fonts/woff
    mkdir -p $out/share/fonts/woff2
    cp *.ttf $out/share/fonts/truetype
    cp *.woff $out/share/fonts/woff
    cp *.woff2 $out/share/fonts/woff2
  '';

  meta = with lib; {
    description = "Replace Font Awesome with modern line icons";
    longDescription = ''
      This package includes only the TTF, WOFF and WOFF2 fonts. For full CSS etc. see the project website.
    '';
    homepage = "https://icons8.com/line-awesome";
    license = licenses.mit;
    maintainers = with maintainers; [ puzzlewolf ];
    platforms = platforms.all;
  };
}
