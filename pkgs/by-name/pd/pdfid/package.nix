{
  lib,
  fetchzip,
  python3,
  python3Packages,
  makeBinaryWrapper,
}:

python3Packages.buildPythonApplication rec {
  pname = "pdfid";
  version = "0.2.10";
  format = "other";

  src = fetchzip {
    url = "https://didierstevens.com/files/software/pdfid_v${
      builtins.replaceStrings [ "." ] [ "_" ] version
    }.zip";
    hash = "sha256-GxQOwIwCVaKEruFO+kxXciOiFcXtBO0vvCwb6683lGU=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/pdfid}
    cp -a * $out/share/pdfid/
    makeWrapper ${lib.getExe python3} $out/bin/pdfid \
      --prefix PYTHONPATH : "$PYTHONPATH" \
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
