{
  lib,
  stdenv,
  fetchFromGitHub,
  gfortran,
  which,
}:

stdenv.mkDerivation rec {
  pname = "packmol";
  version = "20.15.2";

  src = fetchFromGitHub {
    owner = "m3g";
    repo = "packmol";
    rev = "v${version}";
    hash = "sha256-insp8OOQCqyzTYAND0SxBSTA2rYWFgNHKHR+Ws5VStE=";
  };

  nativeBuildInputs = [
    gfortran
    which
  ];

  # This fixes the "/bin/bash: bad interpreter" error
  postPatch = ''
    patchShebangs configure
  '';

  configurePhase = ''
    runHook preConfigure
    # In Nix, since gfortran is in nativeBuildInputs, it is already in your $PATH.
    # We just pass the name 'gfortran' instead of the full store path.
    ./configure gfortran
    runHook postConfigure
  '';

  # Packmol's Makefile uses the FC variable for the Fortran compiler.
  # Explicitly setting it here ensures 'make' knows what to use.
  makeFlags = [ "FC=gfortran" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 packmol -t $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Packing optimization for molecular dynamics simulations";
    longDescription = ''
      Packmol creates initial configurations for molecular dynamics simulations
      by packing molecules in defined regions of space. The packing guarantees
      that short range repulsive interactions do not disrupt the simulations.
    '';
    homepage = "https://m3g.github.io/packmol/";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ Youwes09 ];
    platforms = platforms.linux;
    mainProgram = "packmol";
  };
}
