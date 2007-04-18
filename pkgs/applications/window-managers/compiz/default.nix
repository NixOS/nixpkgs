{ stdenv, fetchurl, pkgconfig, libpng, libXcomposite, libXfixes
, libXdamage, libXrandr, libXinerama, libICE, libSM
, startupnotification, libXrender, xextproto, mesa, gtk, libwnck, GConf
}:

stdenv.mkDerivation {
  name = "compiz-0.5.0";
  src = fetchurl {
    url = http://xorg.freedesktop.org/archive/individual/app/compiz-0.5.0.tar.gz;
    sha256 = "1fac5fc37b218k34lpxqlhs7srqxm7jly0hfncs3ghmjmxdlj03y";
  };
  patches = [
    ./tfp-server-extension.patch
  ];
  buildInputs = [
    pkgconfig libXrender xextproto gtk libwnck GConf
  ];
  propagatedBuildInputs = [
    libpng libXcomposite libXfixes libXdamage libXrandr libXinerama
    libICE libSM startupnotification mesa
  ];
  configureFlags = "--enable-gtk";
}
