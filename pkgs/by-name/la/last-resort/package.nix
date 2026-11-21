{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "last-resort";
  version = "18.000";

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = false; # nothing to build
  doCheck = false; # no tests to run

  src = fetchurl {
    url = "https://github.com/unicode-org/last-resort-font/releases/download/${finalAttrs.version}/LastResortHE-Regular.ttf";
    hash = "sha256-y3wiYsuGoz5736vQpRdG5ziw3RCSQSbEUwxBTF/H5LY=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -D -m 0644 $src $out/share/fonts/truetype/LastResortHE-Regular.ttf

    runHook postInstall
  '';

  meta = {
    description = "Fallback font of last resort";
    homepage = "https://github.com/unicode-org/last-resort-font";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [
      sandarukasa
    ];
  };
})
