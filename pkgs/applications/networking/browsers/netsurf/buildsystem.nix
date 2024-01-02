{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netsurf-buildsystem";
  version = "1.9";

  src = fetchurl {
    url = "http://download.netsurf-browser.org/libs/releases/buildsystem-${finalAttrs.version}.tar.gz";
    hash = "sha256-k4QeMUpoggmiC4dF8GU5PzqQ8Bvmj0Xpa8jS9KKqmio=";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = {
    homepage = "https://www.netsurf-browser.org/";
    description = "NetSurf browser shared build system";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vrthra AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
