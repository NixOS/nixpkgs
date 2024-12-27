{
  lib,
  stdenv,
  fetchurl,
  indent,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdwg";
  version = "0.6";

  src = fetchurl {
    url = "mirror://sourceforge/libdwg/libdwg-${finalAttrs.version}.tar.bz2";
    sha256 = "0l8ks1x70mkna1q7mzy1fxplinz141bd24qhrm1zkdil74mcsryc";
  };

  patches = [
    ./include-missing.patch
    ./add-missing-function-declaration.patch
    ./fix-error-return-value.patch
    ./fix-incorrect-macro-definition.patch
    ./make-dump-error-able.patch
    ./fix-return-value-for-field-xdata.patch
    ./define-dump-entity-handle.patch
    ./missing-ctype-include.patch
  ];

  nativeBuildInputs = [ indent ];

  hardeningDisable = [ "format" ];

  # remove forbidden references to $TMPDIR
  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    for f in "$out"/bin/*; do
      if isELF "$f"; then
        patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" "$f"
      fi
    done
  '';

  meta = {
    description = "Library to read DWG files";
    homepage = "http://libdwg.sourceforge.net/en/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      marcweber
      pandapip1
    ];
    platforms = lib.platforms.linux;
  };
})
