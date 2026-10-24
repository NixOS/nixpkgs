{
  buildNpmPackage,
  src,
  version,
}:

buildNpmPackage {
  pname = "logsonic-frontend";
  inherit version src;

  npmDepsHash = "sha256-mZlv6mREFajOcTuUhVZqYEiDKAhB8gdXMU+LgjH4ILQ=";

  __structuredAttrs = true;

  strictDeps = true;

  sourceRoot = "source/frontend";

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r dist $out/

    runHook postInstall
  '';
}
