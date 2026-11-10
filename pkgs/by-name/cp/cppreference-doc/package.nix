{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "cppreference-doc";
  version = "20250209";

  src = fetchurl {
    url = "https://github.com/PeterFeicht/cppreference-doc/releases/download/v${version}/html-book-${version}.tar.xz";
    hash = "sha256-rFBnGh9S1/CrCRHRRFDrNejC+BLt0OQmss0ePZ25HW8=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/cppreference/doc
    mv reference $out/share/cppreference/doc/html

    runHook postInstall
  '';

  passthru = { inherit pname version; };

  meta = {
    description = "C++ standard library reference";
    homepage = "https://en.cppreference.com";
    license = lib.licenses.cc-by-sa-30;
    maintainers = with lib.maintainers; [ panicgh ];
    platforms = lib.platforms.all;
  };
}
