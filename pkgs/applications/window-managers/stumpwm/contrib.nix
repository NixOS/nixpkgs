{ stdenv, fetchgit }:

let
  tag = "0.9.8";
in

stdenv.mkDerivation rec {
 name = "stumpwmContrib-${tag}";

 src = fetchgit {
   url = "https://github.com/stumpwm/stumpwm";
   rev = "refs/tags/${tag}";
   sha256 = "0a0lwwlly4hlmb30bk6dmi6bsdsy37g4crvv1z24gixippyv1qzm";
 };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
   mkdir -p $out/bin
   cp -a $src/contrib $out/
   cp -a $src/contrib/stumpish $out/bin
 '';

  meta = with stdenv.lib; {
    description = "Extension modules for the StumpWM";
    homepage    = https://github.com/stumpwm/;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ _1126 ];
    platforms   = platforms.linux;
  };
}