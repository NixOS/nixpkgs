{ fetchurl }:

fetchurl (finalAttrs: {
  name = "${finalAttrs.pname}-${finalAttrs.version}.jar";
  pname = "bsh";
  version = "2.1.1";
  url = "https://github.com/beanshell/beanshell/releases/download/${finalAttrs.version}/bsh-${finalAttrs.version}.jar";
  hash = "sha256-cRksu+Seeiac/LoF3Fy5WcM7myba/NYmbKMoi0YfhqM=";
})
