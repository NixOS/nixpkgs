{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  nzportable,
}:
stdenvNoCC.mkDerivation {
  pname = "nzp-quakec";
  version = "0-unstable-2025-11-26";

  src = fetchFromGitHub {
    owner = "nzp-team";
    repo = "quakec";
    rev = "b1d7fec5a536b088283578866ade2c596f7928d0";
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
