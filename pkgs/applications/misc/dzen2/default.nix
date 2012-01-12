{stdenv, fetchurl, libX11, libXinerama, libXpm}:

stdenv.mkDerivation rec {
  name = "dzen2-0.8.5";

  src = fetchurl {
    url = "https://sites.google.com/site/gotmor/dzen2-0.8.5.tar.gz";
    sha256 = "5e4ce96e8ed22a4a0ad6cfafacdde0532d13d049d77744214b196c4b2bcddff9";
  };

  buildInputs = [ libX11 libXinerama libXpm ];

  builder = ./builder.sh;

  patches = [ ./dzenconf.patch ];

  meta = { 
      description = "Dzen is a general purpose messaging, notification and menuing program for X11";
      homepage = https://sites.google.com/site/gotmor/dzen;
      license = "MIT";
  };
}
