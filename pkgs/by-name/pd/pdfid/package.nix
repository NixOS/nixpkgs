{
  lib,
  fetchzip,
  python3,
  python3Packages,
  makeBinaryWrapper,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pdfid";
  version = "0.2.10";
  pyproject = false;

  src = fetchzip {
    url = "https://didierstevens.com/files/software/pdfid_v${
      builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version
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

  meta = {
    description = "Scan a file to look for certain PDF keywords";
    homepage = "https://blog.didierstevens.com/programs/pdf-tools/";
    license = with lib.licenses; [ free ];
    mainProgram = "pdfid";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
