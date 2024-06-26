{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  libtool,
  bison,
  flex,
  automake,
}:

stdenv.mkDerivation (
  import ./common.nix {
    inherit fetchurl lib;
    pname = "linux-gpib-user";
  }
  // {

    nativeBuildInputs = [
      autoconf
      libtool
      bison
      flex
      automake
    ];

    configureFlags = [
      "--sysconfdir=$(out)/etc"
      "--prefix=$(out)"
    ];
  }
)
