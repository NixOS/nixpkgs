{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  fteqcc,
}:
stdenvNoCC.mkDerivation {
  pname = "nzp-quakec";
  version = "0-unstable-2024-11-30-14-44-25";

  src = fetchFromGitHub {
    owner = "nzp-team";
    repo = "quakec";
    rev = "81f7179ebff93304ad762dfe73c12129d8975f96";
    hash = "sha256-MOHmanCSvd9nvoHQcFDhrfE9ssbdxUXok3WQ0h90ev8=";
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
    fteqcc
  ];

  buildPhase = ''
    runHook preBuild

    python3 bin/qc_hash_generator.py -i tools/asset_conversion_table.csv -o source/server/hash_table.qc

    mkdir -p build/{fte,standard}

    fteqcc -srcfile progs/csqc.src
    fteqcc -O3 -DFTE -srcfile progs/ssqc.src
    fteqcc -O3 -DFTE -srcfile progs/menu.src
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
