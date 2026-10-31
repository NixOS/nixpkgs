{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "bai-jamjuree";
  version = "0-unstable-2018-08-08";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cadsondemak";
    repo = "Bai-Jamjuree";
    rev = "7b83d33d948a2e51cd824f186fcd58b2a8207ba7";
    sha256 = "sha256-nPvzHcUimpmi9wUbwlTOwSN+Jbm5XsVRANalBLxGHcQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [ installFonts ];

  outputs = [
    "out"
    "doc"
  ];

  dontInstallWebfonts = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $doc/bai-jamjuree
    cp -r $src/OFL.txt $src/docs/* $doc/bai-jamjuree

    runHook postInstall
  '';

  meta = {
    homepage = "https://cadsondemak.github.io/Bai-Jamjuree";
    description = "Looped Thai and Latin sans serif inspired by Eurostile";
    longDescription = ''
      The silhouette of round corner rectangle was used as the base of the
      design. Along with the unusual unbalanced curves were applied through out
      the set. Bai Jamjuree is walking in the same footstep as Manop
      Srisomporn’s classic “Nopporn” which pretty much inline with Erostile. A
      choice for a distinctive headline and sub headline. Also can be use as
      body text if in need for a unorthodox detail. Rapee Suveeranont and Virot
      Chiraphadhanakul
    '';
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ toastal ];
  };
}
