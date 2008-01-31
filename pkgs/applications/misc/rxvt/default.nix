args: with args;
stdenv.mkDerivation {
  name = "rxvt-2.6.4";

  src = fetchurl {
    url = http://downloads.sourceforge.net/rxvt/rxvt-2.6.4.tar.gz;
    sha256 = "0hi29whjv8v11nkjbq1i6ms411v6csykghmlpkmayfjn9nxr02xg";
  };

  buildInputs = [ libX11 libXt ];

  meta = { 
      description = "colour vt102 terminal emulator with less features and lower memory consumption";
      homepage = http://www.rxvt.org/;
      license = "GPL";
  };
}
