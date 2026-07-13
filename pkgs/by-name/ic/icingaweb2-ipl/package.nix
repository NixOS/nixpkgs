{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  nixosTests,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "icingaweb2-ipl";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "Icinga";
    repo = "icinga-php-library";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rtaXcJGguVZrdH7y3Ex/hgb+5oC+rrkrhllYHMQr9ns=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  installPhase = ''
    mkdir -p "$out"
    cp -r * "$out"
  '';

  passthru.tests = { inherit (nixosTests) icingaweb2; };

  meta = {
    description = "PHP library package for Icingaweb 2";
    homepage = "https://github.com/Icinga/icinga-php-library";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      das_j
      helsinki-Jo
    ];
  };
})
