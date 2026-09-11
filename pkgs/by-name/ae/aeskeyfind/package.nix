{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aeskeyfind";
  version = "1.0";

  src = fetchurl {
    url = "https://citpsite.s3.amazonaws.com/memory-content/src/aeskeyfind-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-FBflwbYehruVJ9sfW+4ZlaDuqCR12zy8iA4Ev3Bgg+Q=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp aeskeyfind $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Locates 128-bit and 256-bit AES keys in a captured memory image";
    mainProgram = "aeskeyfind";
    homepage = "https://citp.princeton.edu/our-work/memory/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fedx-sudo ];
  };

})
