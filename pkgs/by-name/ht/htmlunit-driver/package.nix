{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "htmlunit-driver-standalone";
  version = "2.27";

  src = fetchurl {
    url = "https://github.com/SeleniumHQ/htmlunit-driver/releases/download/${finalAttrs.version}/htmlunit-driver-${finalAttrs.version}-with-dependencies.jar";
    sha256 = "1sd3cwpamcbq9pv0mvcm8x6minqrlb4i0r12q3jg91girqswm2dp";
  };

  dontUnpack = true;

  installPhase = "install -D $src $out/share/lib/${finalAttrs.pname}-${finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}.jar";

  meta = {
    homepage = "https://github.com/SeleniumHQ/htmlunit-driver";
    description = "WebDriver server for running Selenium tests on the HtmlUnit headless browser";
    maintainers = [ ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
  };
})
