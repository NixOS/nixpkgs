{ buildNpmPackage, anubis }:

buildNpmPackage {
  pname = "${anubis.pname}-xess";
  inherit (anubis) version src;

  npmDepsHash = "sha256-jiLrqn0jenug2ff/mqhOIfc7f+CsQja5g2K9n+W1kVM=";

  buildPhase = ''
    runHook preBuild

    npx postcss ./xess/xess.css -o xess.min.css

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 xess.min.css $out/xess.min.css

    runHook postInstall
  '';

  meta = anubis.meta // {
    description = "Xess files for Anubis";
    longDescription = ''
      This package is consumed by the main `anubis` package to render the final
      styling for the bot check page.

      **It is not supposed to be used as a standalone package**, and it exists to
      ensure Anubis' styling is override-able by downstreams.
    '';
  };
}
