{ lib
, fetchzip
, stdenv
, gettext
, libtool
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libbfio";
  version = "20221025";

  src = fetchzip {
    url = "https://github.com/libyal/libbfio/releases/download/${finalAttrs.version}/libbfio-alpha-${finalAttrs.version}.tar.gz";
    hash = "sha256-SwKQlmifyUo49yvo8RV+0nfvScPY5u+UrwjRZK2+qAg=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gettext libtool ];

  meta = {
    description = "Library to provide basic file input/output abstraction";
    homepage = "https://github.com/libyal/libbfio";
    license = with lib.licenses; [ gpl3Plus lgpl3Plus ];
    maintainers = with lib.maintainers; [ d3vil0p3r ];
    platforms = with lib.platforms; unix ++ windows;
  };
})
