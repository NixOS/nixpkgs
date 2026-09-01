{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fleng";
  version = "23";

  src = fetchurl {
    url = "http://www.call-with-current-continuation.org/fleng/fleng-${finalAttrs.version}.tgz";
    hash = "sha256-I8ksy3UAah/LTvtNrzjhw5vNUM55ba80ivo4S/r5yHg=";
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
