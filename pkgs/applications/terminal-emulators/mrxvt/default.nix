{ lib, stdenv, fetchurl, libX11, libXft, libXi, xorgproto, libSM, libICE
, freetype, pkg-config, which }:

stdenv.mkDerivation {
  name = "mrxvt-0.5.4";

  buildInputs =
    [ libX11 libXft libXi xorgproto libSM libICE freetype pkg-config which ];

  configureFlags = [
    "--with-x"
    "--enable-frills"
    "--enable-xft"
    "--enable-xim"
    # "--with-term=xterm"
    "--with-max-profiles=100"
    "--with-max-term=100"
    "--with-save-lines=10000"
  ];

  preConfigure = ''
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${freetype.dev}/include/freetype2";
  '';

  src = fetchurl {
    url = "mirror://sourceforge/materm/mrxvt-0.5.4.tar.gz";
    sha256 = "1mqhmnlz32lvld9rc6c1hyz7gjw4anwf39yhbsjkikcgj1das0zl";
  };

  meta = with lib; {
    description = "Lightweight multitabbed feature-rich X11 terminal emulator";
    longDescription = "
      Multitabbed lightweight terminal emulator based on rxvt.
      Supports transparency, backgroundimages, freetype fonts, ...
    ";
    homepage = "https://sourceforge.net/projects/materm";
    license = licenses.gpl2;
    platforms = platforms.linux;
    knownVulnerabilities = [
      "Usage of ANSI escape sequences causes unexpected newline-termination, leading to unexpected command execution (https://www.openwall.com/lists/oss-security/2021/05/17/1)"
    ];
  };
}
