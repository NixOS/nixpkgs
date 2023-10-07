{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, makeWrapper
, fftw
, lapack
, openblas
, runCommandLocal
, raspa
, raspa-data
}:
stdenv.mkDerivation rec {
  pname = "raspa";
  version = "2.0.47";

  src = fetchFromGitHub {
    owner = "iRASPA";
    repo = "RASPA2";
    rev = "v${version}";
    hash = "sha256-i8Y+pejiOuyPNJto+/0CmRoAnMljCrnDFx8qDh4I/68=";
  };

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
  ];

  buildInputs = [
    fftw
    lapack
    openblas
  ];

  # Prepare for the Python binding packaging.
  strictDeps = true;

  enableParallelBuilding = true;

  preAutoreconf = ''
    mkdir "m4"
  '';

  postAutoreconf = ''
    automake --add-missing
    autoconf
  '';

  doCheck = true;

  # Wrap with RASPA_DIR
  # so that users can run $out/bin/simulate directly
  # without the need of a `run` srcipt.
  postInstall = ''
    wrapProgram "$out/bin/simulate" \
      --set RASPA_DIR "$out"
  '';

  passthru.tests.run-an-example = runCommandLocal "raspa-test-run-an-example" { }
    ''
      set -eu -o pipefail
      exampleDir="${raspa-data}/share/raspa/examples/Basic/1_MC_Methane_in_Box"
      exampleDirWritable="$(basename "$exampleDir")"
      cp -rT "$exampleDir" "./$exampleDirWritable"
      chmod u+rw -R "$exampleDirWritable"
      cd "$exampleDirWritable"
      ${raspa}/bin/simulate
      touch "$out"
    '';

  meta = with lib; {
    description = "A general purpose classical molecular simulation package";
    homepage = "https://iraspa.org/raspa/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ ShamrockLee ];
    mainProgram = "simulate";
  };
}
