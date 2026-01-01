{
  lib,
  stdenv,
  fetchurl,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "fakeroute";
  version = "0.3";

  src = fetchurl {
    url = "https://maxwell.eurofusion.eu/git/rnhmjoj/fakeroute/releases/download/v${version}/fakeroute-${version}.tar.gz";
    hash = "sha256-DoXGJm8vOlAD6ZuvVAt6bkgfahc8WgyYIXCrgqzfiWg=";
  };

  passthru.tests.fakeroute = nixosTests.fakeroute;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = ''
      Make your machine appears to be anywhere on the internet in a traceroute
    '';
    homepage = "https://maxwell.eurofusion.eu/git/rnhmjoj/fakeroute";
<<<<<<< HEAD
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
=======
    license = licenses.bsd3;
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "fakeroute";
  };
}
