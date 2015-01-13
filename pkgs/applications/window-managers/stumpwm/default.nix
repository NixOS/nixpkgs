{ stdenv, pkgs, fetchgit, autoconf, sbcl, lispPackages, xdpyinfo, texinfo4, makeWrapper, stumpwmContrib }:

let
  tag = "0.9.9";
in

stdenv.mkDerivation rec {
 name = "stumpwm-${tag}";

 src = fetchgit {
   url = "https://github.com/stumpwm/stumpwm";
   rev = "refs/tags/${tag}";
   sha256 = "05fkng2wlmhy3kb9zhrrv9zpa16g2p91p5y0wvmwkppy04cw04ps";
 };

 buildInputs = [ texinfo4 autoconf lispPackages.clx lispPackages.cl-ppcre sbcl makeWrapper stumpwmContrib ];

 phases = [ "unpackPhase" "preConfigurePhase" "configurePhase" "installPhase" ];

 preConfigurePhase = ''
   $src/autogen.sh
   mkdir -pv $out/bin
 '';

 configurePhase = ''
   ./configure --prefix=$out --with-contrib-dir=${stumpwmContrib}/contrib
 '';

 installPhase = ''
   make
   make install
   # For some reason, stumpwmContrib is not retained as a runtime
   # dependency (probably because $out/bin/stumpwm is compressed or
   # obfuscated in some way). Thus we add an explicit reference here.
   mkdir $out/nix-support
   echo ${stumpwmContrib} > $out/nix-support/stumpwm-contrib
 '';

  meta = with stdenv.lib; {
    description = "A tiling window manager for X11";
    homepage    = https://github.com/stumpwm/;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ _1126 ];
    platforms   = platforms.linux;
  };
}
