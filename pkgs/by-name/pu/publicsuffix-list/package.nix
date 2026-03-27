{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "publicsuffix-list";
  version = "0-unstable-2026-03-02";

  src = fetchFromGitHub {
    owner = "publicsuffix";
    repo = "list";
    rev = "7ef6384612e1b48bb8b6023716cc9a493ac25d8a";
    hash = "sha256-AVVRW373eC2YpsoeuefSv8y+MMp7UfHrd0aXLEiLpsY=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm0444 public_suffix_list.dat tests/test_psl.txt -t $out/share/publicsuffix

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://publicsuffix.org/";
    description = "Cross-vendor public domain suffix database";
    platforms = lib.platforms.all;
    license = lib.licenses.mpl20;
    maintainers = [ ];
  };
}
