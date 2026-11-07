{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.11.13";
  pname = "coinutils";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "CoinUtils";
    rev = "releases/${finalAttrs.version}";
    hash = "sha256-fxg6kbCY9cMdJhNGddR9/qUxiR6KamUSDyzW8JxFlbo=";
  };

  doCheck = true;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    license = lib.licenses.epl20;
    homepage = "https://github.com/coin-or/CoinUtils";
    description = "Collection of classes and helper functions that are generally useful to multiple COIN-OR projects";
    maintainers = with lib.maintainers; [ tmarkus ];
    pkgConfigModules = [ "coinutils" ];
  };
})
