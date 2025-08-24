{
  lib,
  gobjcStdenv,
  fetchurl,
  gnustep-libobjc,
  which,
}:

gobjcStdenv.mkDerivation (finalAttrs: {
  pname = "gnustep-make-gcc";
  version = "2.9.3";

  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-make-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-k8oyC3BieevKU3YNqJ1MPyu8VH9HI5ZxQKNDRtnwTCQ=";
  };

  configureFlags = [
    "--with-layout=fhs-system"
    "--disable-install-p"
  ];

  preConfigure = ''
    configureFlags="$configureFlags --with-config-file=$out/etc/GNUstep/GNUstep.conf"
  '';

  makeFlags = [
    "GNUSTEP_INSTALLATION_DOMAIN=SYSTEM"
  ];

  buildInputs = [ gnustep-libobjc ];

  propagatedBuildInputs = [ which ];

  patches = [ ../gnustep-make/fixup-paths.patch ];
  setupHook = ../gnustep-make/setup-hook.sh;

  meta = {
    changelog = "https://github.com/gnustep/tools-make/releases/tag/make-${
      builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }";
    description = "Build manager for GNUstep";
    homepage = "https://gnustep.github.io/";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [
      ashalkhakov
      dblsaiko
      matthewbauer
    ];
    platforms = lib.platforms.unix;
  };
})
