{
  lib,
  stdenvNoCC,
  haskellPackages,
  fetchurl,
  writers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hledger-check-fancyassertions";
  inherit (haskellPackages.hledger-lib) version;

  src = fetchurl {
    name = "hledger-check-fancyassertion-${finalAttrs.version}.hs";
    url = "https://raw.githubusercontent.com/simonmichael/hledger/hledger-lib-${finalAttrs.version}/bin/hledger-check-fancyassertions.hs";
    hash = "sha256-ISA7ED0HgyWOxfaufaFpNb1dHfE+1+Xh4SRCZ64yM6E=";
  };

  dontUnpack = true;
  dontBuild = true;

  executable = writers.writeHaskell "hledger-check-fancyassertions" {
    libraries = with haskellPackages; [
      hledger-lib
      base
      base-compat
      base-compat-batteries
      filepath
      megaparsec
      microlens
      optparse-applicative
      string-qq
      text
      time
      transformers
    ];
    inherit (haskellPackages) ghc;
  } finalAttrs.src;

  installPhase = ''
    runHook preInstall
    install -D $executable $out/bin/${finalAttrs.pname}
    runHook postInstall
  '';

  meta = {
    description = "Complex account balance assertions for hledger journals";
    homepage = "https://hledger.org/";
    changelog = "https://github.com/simonmichael/hledger/blob/${finalAttrs.version}/hledger/CHANGES.md";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.DamienCassou ];
    platforms = lib.platforms.all; # GHC can cross-compile
    mainProgram = "hledger-check-fancyassertions";
  };
})
