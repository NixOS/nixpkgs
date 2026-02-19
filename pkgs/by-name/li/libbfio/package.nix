{
  lib,
  fetchzip,
  stdenv,
  gettext,
  libtool,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libbfio";
  version = "20240414";

  src = fetchzip {
    url = "https://github.com/libyal/libbfio/releases/download/${finalAttrs.version}/libbfio-alpha-${finalAttrs.version}.tar.gz";
    hash = "sha256-xxMHOSVpGyw5rGXhU1tIOTKwt9yVw0KrPdYby0AEdv8=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gettext
    libtool
  ];

  meta = {
    description = "Library to provide basic file input/output abstraction";
    homepage = "https://github.com/libyal/libbfio";
    license = with lib.licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    maintainers = [ ];
    platforms = with lib.platforms; unix ++ windows;
  };
})
