{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fleng";
  version = "15";

  src = fetchurl {
    url = "http://www.call-with-current-continuation.org/fleng/fleng-${finalAttrs.version}.tgz";
    hash = "sha256-gLRaLty7dxpcmIJEBn7mF/RMFhjCuAYl16FR70FYZWA=";
  };

  doCheck = true;

  meta = {
    homepage = "http://www.call-with-current-continuation.org/fleng/fleng.html";
    description = "A low level concurrent logic programming language descended from Prolog";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
# TODO: bootstrap
