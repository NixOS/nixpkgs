{ fetchFromGitHub
, crystal
}:
crystal.buildCrystalPackage rec {
  pname = "blake3.cr";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "GeopJr";
    repo = "blake3.cr";
    rev = "v${version}";
    hash = "sha256-jRdFnLvQ8Wuwjap3HseLZW/5ncQKI3A47XW6V9aBg10=";
  };

  format = "crystal";
  crystalBinaries.blake3-cr-bin.src = "src/blake3.cr";

  installPhase = ''
    runHook preInstall

    rm -rf .crystal/
    rm blake3-cr-bin
    mkdir $out
    cp -r . $out/

    runHook postInstall
  '';
}
