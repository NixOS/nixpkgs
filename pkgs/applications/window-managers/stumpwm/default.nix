{ stdenv, pkgs, fetchgit, autoconf, sbcl, lispPackages, xdpyinfo, texinfo4, makeWrapper, stumpwmContrib }:

let
  tag = "0.9.8";
in

stdenv.mkDerivation rec {
 name = "stumpwm-${tag}";

 src = fetchgit {
   url = "https://github.com/stumpwm/stumpwm";
   rev = "refs/tags/${tag}";
   sha256 = "0a0lwwlly4hlmb30bk6dmi6bsdsy37g4crvv1z24gixippyv1qzm";
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
   # STUMPWM_CONTRIB_DIR is not actually used. We just set it so that
   # stumpwmContrib gets retained as a runtime dependency because for
   # some reason $out/bin/stumpwm does not contain a reference to it.
   wrapProgram $out/bin/stumpwm --set STUMPWM_CONTRIB_DIR "${stumpwmContrib}/contrib"
 '';

  meta = with stdenv.lib; {
    description = "A tiling window manager for X11";
    homepage    = https://github.com/stumpwm/;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ _1126 ];
    platforms   = platforms.linux;
  };
}