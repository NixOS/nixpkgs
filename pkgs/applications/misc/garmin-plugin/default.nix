{ lib, stdenv, fetchurl, garmintools, libgcrypt, libusb-compat-0_1, pkg-config, tinyxml, zlib }:
stdenv.mkDerivation {
  name = "garmin-plugin-0.3.26";
  src = fetchurl {
    url = "https://github.com/adiesner/GarminPlugin/archive/V0.3.26.tar.gz";
    sha256 = "15gads1fj4sj970m5960dgnhys41ksi4cm53ldkf67wn8dc9i4k0";
  };
  sourceRoot = "GarminPlugin-0.3.26/src";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ garmintools libusb-compat-0_1 libgcrypt tinyxml zlib ];
  configureFlags = [
    "--with-libgcrypt-prefix=${libgcrypt.dev}"
    "--with-garmintools-incdir=${garmintools}/include"
    "--with-garmintools-libdir=${garmintools}/lib"
  ];
  installPhase = ''
    mkdir -p $out/lib/mozilla/plugins
    cp npGarminPlugin.so $out/lib/mozilla/plugins
  '';
  meta = {
    homepage = "http://www.andreas-diesner.de/garminplugin";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
