{ lib
, fetchzip
, python3
, python3Packages
, makeBinaryWrapper
}:

python3Packages.buildPythonApplication rec {
  pname = "pdfid";
  version = "0.2.8";
  format = "other";

  src = fetchzip {
    url = "https://didierstevens.com/files/software/pdfid_v0_2_8.zip";
    hash = "sha256-ZLyhBMF2KMX0c1oCvuSCjEjHTnm2gFhJtasaTD9Q1BI=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/pdfid}
    cp -a * $out/share/pdfid/
    makeBinaryWrapper ${lib.getExe python3} $out/bin/${meta.mainProgram} \
      --add-flags "$out/share/pdfid/pdfid.py"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Scan a file to look for certain PDF keywords";
    homepage = "https://blog.didierstevens.com/programs/pdf-tools/";
    license = with licenses; [ free ];
    mainProgram = "pdfid";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
  };
}
