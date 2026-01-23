{ fetchurl }:

fetchurl (finalAttrs: {
  name = "${finalAttrs.pname}-${finalAttrs.version}.jar";
  pname = "bsh";
  version = "2.0b5";
  url = "http://www.beanshell.org/bsh-${finalAttrs.version}.jar";
  hash = "sha256-YjIZlWOAc1SzvLWs6z3BNlAvAixrDvdDmHqD9m/uWlw=";
})
