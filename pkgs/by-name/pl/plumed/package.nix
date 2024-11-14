{ stdenv
, lib
, fetchFromGitHub
, blas
}:

assert !blas.isILP64;

stdenv.mkDerivation rec {
  pname = "plumed";
  version = "2.9.2";

  src = fetchFromGitHub {
    owner = "plumed";
    repo = "plumed2";
    rev = "v${version}";
    hash = "sha256-jNvdbfh1krNMrOFqkEHMy60mjsG/Wp6MQg0gHEjDA5U=";
  };

  postPatch = ''
    patchShebangs .
  '';

  buildInputs = [ blas ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Molecular metadynamics library";
    homepage = "https://github.com/plumed/plumed2";
    license = licenses.lgpl3Only;
    maintainers = [ maintainers.sheepforce ];
  };
}
