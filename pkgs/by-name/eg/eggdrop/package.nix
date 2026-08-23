{
  lib,
  stdenv,
  fetchurl,
  openssl,
  tcl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eggdrop";
  version = "1.10.1";

  src = fetchurl {
    url = "https://ftp.eggheads.org/pub/eggdrop/source/${lib.versions.majorMinor finalAttrs.version}/eggdrop-${finalAttrs.version}.tar.gz";
    hash = "sha256-pc33RE14HC/09dC+FCAvXQlx4AOHGBpJtyUFf+lTEtU=";
  };

  buildInputs = [
    openssl
    tcl
  ];

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
    maintainers = with lib.maintainers; [ EpicEric ];
  };
})
