{
  lib,
  stdenv,
  fetchurl,
  bison,
  flex,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "oidentd";
  version = "3.1.0";
  nativeBuildInputs = [
    bison
    flex
  ];

  src = fetchurl {
    url = "https://files.janikrabe.com/pub/oidentd/releases/${finalAttrs.version}/oidentd-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-yyvcnabxNkcIMOiZBjvoOm/pEjrGXFt4W4SG5lprkbc=";
  };

  meta = {
    description = "Configurable Ident protocol server";
    mainProgram = "oidentd";
    homepage = "https://oidentd.janikrabe.com/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
})
