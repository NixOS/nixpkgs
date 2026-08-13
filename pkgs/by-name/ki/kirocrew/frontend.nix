{
  lib,
  buildNpmPackage,
  nodejs_22,
  kirocrew,
}:

buildNpmPackage (finalAttrs: {
  pname = "kirocrew-frontend";
  inherit (kirocrew) version src;

  sourceRoot = "${finalAttrs.src.name}/website";

  nodejs = nodejs_22;

  npmDepsHash = "sha256-gcG8pYQnBied9VR6ChCndli/F1iAcnWyhZu9Pu9QMI4=";

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
