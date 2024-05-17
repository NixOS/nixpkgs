{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  nzp-fteqw,
  nzportable,
}:
let
  suffix = if stdenvNoCC.isDarwin then "mac" else "lin";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nzp-quakec";
  version = "0-unstable-2024-06-05-03-16-25";

  src = fetchFromGitHub {
    owner = "nzp-team";
    repo = "quakec";
    rev = "0d06eae388ff692cdd0222ace7671c7374b8b7a3";
    hash = "sha256-5JVZFKsxXueNrt0IRQeGRD3tkMnhwZhSk/MQrY6/ARs=";
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
  ];

  postPatch = ''
    patchShebangs tools/qc-compiler-${suffix}.sh

    # Avoid needing to run the script in the tools/ directory, and use our own FTEQCC
    substituteInPlace tools/qc-compiler-${suffix}.sh \
      --replace-fail "cd ../" "" \
      --replace-fail "./fteqcc-cli-${suffix}" "${lib.getExe' nzp-fteqw.fteqcc "fteqcc"}"
  '';

  buildPhase = ''
    runHook preBuild

    ./tools/qc-compiler-${suffix}.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out $fte
    cp -r build/standard/* $out
    cp -r build/fte/* $fte

    runHook postInstall
  '';

  passthru.updateScript = nzportable.nzp-update {
    inherit (finalAttrs.src) owner repo;
    tag = "bleeding-edge";
  };

  meta = {
    description = "QuakeC repository for Nazi Zombies: Portable";
    homepage = "https://github.com/nzp-team/quakec";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [ pluiedev ];
  };
})
