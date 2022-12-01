{lib, stdenvNoCC, haskellPackages, fetchurl, writers}:

stdenvNoCC.mkDerivation rec {
  pname = "hledger-check-fancyassertions";
  inherit (haskellPackages.hledger-lib) version;

  src = fetchurl {
    name = "hledger-check-fancyassertion-${version}.hs";
    url = "https://raw.githubusercontent.com/simonmichael/hledger/hledger-lib-${version}/bin/hledger-check-fancyassertions.hs";
    sha256 = "1xy3ssxnwybq40nlffz95w7m9xbzf8ysb13svg0i8g5sfgrw11vk";
  };

  dontUnpack = true;
  dontBuild = true;

  executable = writers.writeHaskell
    "hledger-check-fancyassertions"
    {
      libraries = with haskellPackages; [
        hledger-lib
        base base-compat base-compat-batteries filepath
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
