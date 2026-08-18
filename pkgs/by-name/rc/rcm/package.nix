{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rcm";
  version = "1.3.6";

  src = fetchurl {
    url = "https://thoughtbot.github.io/rcm/dist/rcm-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-9P37xFHR+1dkUxKQogKgqHH2uBujwBprdsSUNchQgKU=";
  };

  patches = [ ./fix-rcmlib-path.patch ];

  postPatch = ''
    for f in bin/*.in; do
      substituteInPlace $f --subst-var-by rcm $out
    done
  '';

  meta = {
    homepage = "https://github.com/thoughtbot/rcm";
    description = "Management Suite for Dotfiles";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      malyn
    ];
    platforms = with lib.platforms; unix;
  };
})
