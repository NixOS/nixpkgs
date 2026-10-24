{
  lib,
  stdenv,
  fetchFromGitHub,
  gfortran,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "packmol";
  version = "20.15.2";

  src = fetchFromGitHub {
    owner = "m3g";
    repo = "packmol";
    tag = "v${finalAttrs.version}";
    hash = "sha256-insp8OOQCqyzTYAND0SxBSTA2rYWFgNHKHR+Ws5VStE=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ gfortran ];

  dontConfigure = true;

  makeFlags = [
    "FORTRAN=${stdenv.cc.targetPrefix}gfortran"
    "FLAGS=-O3 -ffast-math -funroll-loops"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 packmol -t $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Packing optimization for molecular dynamics simulations";
    longDescription = ''
      Packmol creates initial configurations for molecular dynamics simulations
      by packing molecules in defined regions of space. The packing guarantees
      that short range repulsive interactions do not disrupt the simulations.
    '';
    homepage = "https://m3g.github.io/packmol/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Youwes09 ];
    platforms = lib.platforms.unix;
    mainProgram = "packmol";
  };
})
