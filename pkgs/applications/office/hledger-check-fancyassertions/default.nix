{lib, stdenvNoCC, haskellPackages, fetchurl, writers}:

stdenvNoCC.mkDerivation rec {
  pname = "hledger-check-fancyassertions";
  version = "1.23";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/simonmichael/hledger/hledger-lib-${version}/bin/hledger-check-fancyassertions.hs";
    sha256 = "08p2din1j7l4c29ipn68k8vvs3ys004iy8a3zf318lzby4h04h0n";
  };

  dontUnpack = true;
  dontBuild = true;

  executable = writers.writeHaskell
    "hledger-check-fancyassertions"
    {
      libraries = with haskellPackages; [
        base base-compat base-compat-batteries filepath hledger-lib_1_23
        megaparsec microlens optparse-applicative string-qq text time
        transformers
      ];
      inherit (haskellPackages) ghc;
    }
    src;

  installPhase = ''
    runHook preInstall
    install -D $executable $out/bin/${pname}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Complex account balance assertions for hledger journals";
    homepage = "https://hledger.org/";
    changelog = "https://github.com/simonmichael/hledger/blob/master/CHANGES.md";
    license = licenses.gpl3;
    maintainers = [ maintainers.DamienCassou ];
    platforms = lib.platforms.all; # GHC can cross-compile
  };
}
