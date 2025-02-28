{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  nzportable,
}:
stdenvNoCC.mkDerivation {
  pname = "nzp-quakec";
  version = "0-unstable-2024-10-12-12-03-59";

  src = fetchFromGitHub {
    owner = "nzp-team";
    repo = "quakec";
    rev = "01e95c4dab91ce0e8b7387d2726d9ee307792ae7";
    hash = "sha256-h4llx3tzeoI1aHLokM7NqkZJWuo6rcrmWfb0pDQL+zM=";
  };

  outputs = [
    "out"
    "fte"
  ];

  nativeBuildInputs = [ python3 ];

  buildInputs = with python3.pkgs; [
    colorama
    fastcrc
    pandas
    nzportable.fteqw
  ];

  buildPhase = ''
    runHook preBuild

    python3 bin/qc_hash_generator.py -i tools/asset_conversion_table.csv -o source/server/hash_table.qc

    mkdir -p build/{fte,standard}

    fteqcc -srcfile progs/csqc.src
    fteqcc -O3 -DFTE -srcfile progs/ssqc.src
    fteqcc -O3 -srcfile progs/ssqc.src

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out $fte
    cp -r build/standard/* $out
    cp -r build/fte/* $fte

    runHook postInstall
  '';

  meta = {
    description = "QuakeC repository for Nazi Zombies: Portable";
    homepage = "https://github.com/nzp-team/quakec";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [ pluiedev ];
  };
}
