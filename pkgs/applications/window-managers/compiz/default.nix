{ stdenv, fetchurl, pkgconfig, libpng, libXcomposite, libXfixes
, libXdamage, libXrandr, libXinerama, libICE, libSM
, startupnotification, libXrender, xextproto, mesa, gtk, libwnck, GConf
}:

stdenv.mkDerivation {
  name = "compiz-0.3.6";
  src = fetchurl {
    url = http://xorg.freedesktop.org/archive/individual/app/compiz-0.3.6.tar.bz2;
    sha256 = "0z7cprg510x1sjzsj8h02l1q5h7qvhcn7z94b7a48pxv124z7qpg";
  };
  patches = fetchurl {
    url = http://gandalfn.club.fr/ubuntu/compiz-patch/02-tfp-server-extension.patch;
    sha256 = "1hi53ajypmgsyfz7cziccdk9f8mn3pfl255yjzl0v15nv5kacmiq";
  };
  buildInputs = [
    pkgconfig libpng libXcomposite libXfixes libXdamage libXrandr
    libXinerama libICE libSM startupnotification libXrender xextproto
    mesa gtk libwnck GConf
  ];
  configureFlags = "--enable-gtk";
}
