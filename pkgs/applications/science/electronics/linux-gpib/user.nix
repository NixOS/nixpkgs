{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  libtool,
  bison,
  flex,
  automake,
  udevCheckHook,
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
      udevCheckHook
    ];

    configureFlags = [
      "--sysconfdir=$(out)/etc"
      "--prefix=$(out)"
    ];

    doInstallCheck = true;
  }
)
