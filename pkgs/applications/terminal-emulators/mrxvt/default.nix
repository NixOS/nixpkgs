{ lib
, stdenv
, fetchurl
, libX11
, libXft
, libXi
, xorgproto
, libSM
, libICE
, freetype
, pkg-config
, which
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "mrxvt";
  version = "0.5.4";

  src = fetchurl {
    url = "mirror://sourceforge/materm/mrxvt-${version}.tar.gz";
    sha256 = "1mqhmnlz32lvld9rc6c1hyz7gjw4anwf39yhbsjkikcgj1das0zl";
  };

  buildInputs = [ libX11 libXft libXi xorgproto libSM libICE freetype pkg-config which ];

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

  passthru.tests.test = nixosTests.terminal-emulators.mrxvt;

  meta = with lib; {
    description = "Lightweight multitabbed feature-rich X11 terminal emulator";
    longDescription = "
      Multitabbed lightweight terminal emulator based on rxvt.
      Supports transparency, backgroundimages, freetype fonts, ...
    ";
    homepage = "https://sourceforge.net/projects/materm";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
    knownVulnerabilities = [
      "Usage of ANSI escape sequences causes unexpected newline-termination, leading to unexpected command execution (https://www.openwall.com/lists/oss-security/2021/05/17/1)"
    ];
  };
}
