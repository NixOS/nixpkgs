{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libmnl,
}:

stdenv.mkDerivation rec {
  pname = "libnetfilter_cthelper";
  version = "1.0.1";

  src = fetchurl {
    url = "https://netfilter.org/projects/libnetfilter_cthelper/files/${pname}-${version}.tar.bz2";
    sha256 = "sha256-FAc9VIcjOJc1XT/wTdwcjQPMW6jSNWI2qogWGp8tyRI=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libmnl ];

  meta = {
    description = "Userspace library that provides the programming interface to the user-space connection tracking helper infrastructure";
    longDescription = ''
      libnetfilter_cthelper is the userspace library that provides the programming interface
      to the user-space helper infrastructure available since Linux kernel 3.6. With this
      library, you register, configure, enable and disable user-space helpers. This library
      is used by conntrack-tools.
    '';
    homepage = "https://www.netfilter.org/projects/libnetfilter_cthelper/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
