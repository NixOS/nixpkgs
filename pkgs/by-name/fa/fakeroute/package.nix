{
  lib,
  stdenv,
  fetchurl,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fakeroute";
  version = "0.3";

  src = fetchurl {
    url = "https://maxwell.eurofusion.eu/git/rnhmjoj/fakeroute/releases/download/v${finalAttrs.version}/fakeroute-${finalAttrs.version}.tar.gz";
    hash = "sha256-DoXGJm8vOlAD6ZuvVAt6bkgfahc8WgyYIXCrgqzfiWg=";
  };

  passthru.tests.fakeroute = nixosTests.fakeroute;

  meta = {
    description = ''
      Make your machine appears to be anywhere on the internet in a traceroute
    '';
    homepage = "https://maxwell.eurofusion.eu/git/rnhmjoj/fakeroute";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    mainProgram = "fakeroute";
  };
})
