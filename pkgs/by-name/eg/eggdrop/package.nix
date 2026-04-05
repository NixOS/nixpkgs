{
  lib,
  stdenv,
  fetchurl,
  tcl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eggdrop";
  version = "1.9.5";

  src = fetchurl {
    url = "https://ftp.eggheads.org/pub/eggdrop/source/${lib.versions.majorMinor finalAttrs.version}/eggdrop-${finalAttrs.version}.tar.gz";
    hash = "sha256-4mkY6opk2YV1ecW2DGYaM38gdz7dgwhrNWUlvrWBc2o=";
  };

  buildInputs = [ tcl ];

  hardeningDisable = [ "format" ];

  preConfigure = ''
    prefix=$out/eggdrop
    mkdir -p $prefix
  '';

  postConfigure = ''
    make config
  '';

  configureFlags = [
    "--with-tcllib=${tcl}/lib/lib${tcl.libPrefix}${stdenv.hostPlatform.extensions.sharedLibrary}"
    "--with-tclinc=${tcl}/include/tcl.h"
  ];

  meta = {
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    homepage = "https://www.eggheads.org";
    description = "Internet Relay Chat (IRC) bot";
  };
})
