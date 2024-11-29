{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tslib";
  version = "1.23";
  hash = "sha256-2YJDADh/WCksAEIjngAdji98YGmwjpvxSBZkxAwFc7k=";

  src = fetchFromGitHub {
    owner = "libts";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    sha256 = finalAttrs.hash;
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Touchscreen access library";
    homepage = "http://www.tslib.org/";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ shogo ];
  };
})
