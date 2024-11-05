{
  fetchurl,
  lib,
  zlib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "gensort";
  version = "1.5";

  src = fetchurl {
    url = "https://www.ordinal.com/try.cgi/gensort-${finalAttrs.version}.tar.gz";
    hash = "sha256-f3VzeD2CmM7z3Uqh24IlyRTeGgz+0oOWXqILaYOKZ60=";
  };

  buildInputs = [
    zlib
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=format-security";

  installPhase = ''
    runHook preInstall
    install -Dm755 gensort $out/bin/gensort
    install -Dm755 valsort $out/bin/valsort
    runHook postInstall
  '';

  meta = {
    description = "Generate and validate records for the sorting benchmark";
    longDescription = ''
      The gensort program can be used to generate input records for the sort
      benchmarks presented on www.sortbenchmark.org.

      The valsort program can be used to validate the sort output file is
      correct.
    '';
    homepage = "https://www.ordinal.com/gensort.html";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ zimeg ];
    mainProgram = "gensort";
    platforms = lib.platforms.linux;
  };
})
