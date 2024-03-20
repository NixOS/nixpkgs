{ stdenv
, fetchFromGitHub
, lib
}: stdenv.mkDerivation (final: {
  pname = "cohomCalg";
  version = "0.32";

  src = fetchFromGitHub {
    owner = "BenjaminJurke";
    repo = "cohomCalg";
    rev = "v${final.version}";
    hash = "sha256-9kKKfb8STiCjaHiWgYEQsERNTnOXlwN8axIBJHg43zk=";
  };
  patches = [
    ./makefile.patch
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/cohomcalg $out/bin/cohomcalg
    runHook postInstall
  '';

  meta = with lib; {
    description = "A software package for computation of sheaf cohomologies for line bundles on toric varieties";
    homepage = "https://github.com/BenjaminJurke/cohomCalg";
    license = with licenses; [ gpl3Plus ];
    mainProgram = "cohomcalg";
    maintainers = with maintainers; [ alois31 ];
    sourceProvenance = with sourceTypes; [ fromSource ];
  };
})
