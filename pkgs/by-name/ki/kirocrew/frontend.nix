{
  lib,
  buildNpmPackage,
  nodejs_22,
  kirocrew,
}:

buildNpmPackage (finalAttrs: {
  pname = "kirocrew-frontend";
  inherit (kirocrew) version src;

  # The dashboard SPA lives in the website/ subtree of the same source tree
  # the Python package is built from.
  sourceRoot = "${finalAttrs.src.name}/website";

  nodejs = nodejs_22;

  # website/package.json declares "engines": { "node": ">=22" }.
  # The "build" script (tsc -b && vite build) emits dist/, which
  # buildNpmPackage runs by default (npmBuildScript = "build").

  npmDepsHash = "sha256-MbYjABng7WvkaowDe7P4kzCDAlCiWGtGWpO0KswjngI=";

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  meta = {
    description = "Web dashboard SPA for Kiro Crew (React + TypeScript + Vite)";
    inherit (kirocrew.meta) homepage license platforms;
  };
})
