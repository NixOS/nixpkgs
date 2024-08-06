{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, autoconf, automake, pkg-config, glib
, perl, ncurses5, hamlib, xmlrpc_c }:

stdenv.mkDerivation rec {
  pname = "tlf";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "1xpgs4k27pjd9mianfknknp6mf34365bcp96wrv5xh4dhph573rj";
  };

  patches = [
    # Pull upstream fix for ncurses-6.3:
    #   https://github.com/Tlf/tlf/pull/282
    # We use Debian's patch as upstream fixes don't apply as is due to
    # related code changes. The change will be a part of 1.4.2 release.
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://salsa.debian.org/debian-hamradio-team/tlf/-/raw/5a2d79fc35bde97f653b1373fd970d41fe01a3ec/debian/patches/warnings-as-errors.patch?inline=false";
      sha256 = "1zi1dd4vqkgl2pg29lnhj91ralqg58gmkzq9fkcx0dyakbjm6070";
    })
  ];

  nativeBuildInputs = [ autoreconfHook autoconf automake pkg-config perl ];
  buildInputs = [ glib ncurses5 hamlib xmlrpc_c ];

  configureFlags = [ "--enable-hamlib" "--enable-fldigi-xmlrpc" ];

  postInstall = ''
    mkdir -p $out/lib
    ln -s ${ncurses5.out}/lib/libtinfo.so.5 $out/lib/libtinfo.so.5
  '';

  meta = with lib; {
    description = "Advanced ham radio logging and contest program";
    longDescription = ''
      TLF is a curses based console mode general logging and contest program for
      amateur radio.

      It supports the CQWW, the WPX, the ARRL-DX, the ARRL-FD, the PACC and the
      EU SPRINT shortwave contests (single operator) as well as a LOT MORE basic
      contests, general QSO and DXpedition mode.
    '';
    homepage = "https://tlf.github.io/";
    license = licenses.gpl2;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
