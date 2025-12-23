{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fleng";
  version = "20";

  src = fetchurl {
    url = "http://www.call-with-current-continuation.org/fleng/fleng-${finalAttrs.version}.tgz";
    hash = "sha256-kkouDNbdVGE7vskmu8kISA/RHIGed5vLY/ch4qgew3g=";
  };

  doCheck = true;

  meta = {
    homepage = "http://www.call-with-current-continuation.org/fleng/fleng.html";
    description = "Low level concurrent logic programming language descended from Prolog";
    license = lib.licenses.publicDomain;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
# TODO: bootstrap
