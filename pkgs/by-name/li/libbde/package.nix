{
  lib,
  stdenv,
  fetchurl,
  fuse,
  ncurses,
  python3,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libbde";
  version = "20240502";

  src = fetchurl {
    url = "https://github.com/libyal/libbde/releases/download/${finalAttrs.version}/libbde-alpha-${finalAttrs.version}.tar.gz";
    hash = "sha256-La6rzBOfyBIXDn78vXb8GUt8jgQkzsqM38kRZ7t3Fp0=";
  };

  buildInputs = [
    fuse
    ncurses
    python3
  ];

  preInstall = ''
    substituteInPlace pybde/Makefile \
      --replace-fail '$(LIBTOOL) $(AM_LIBTOOLFLAGS) $(LIBTOOLFLAGS) --mode=install' ' '
  '';

  configureFlags = [ "--enable-python" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Library to access the BitLocker Drive Encryption (BDE) format";
    homepage = "https://github.com/libyal/libbde/";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [
      eliasp
      bot-wxt1221
    ];
    platforms = lib.platforms.all;
  };
})
