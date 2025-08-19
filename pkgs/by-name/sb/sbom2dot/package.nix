{
  python3Packages,
}:

(python3Packages.toPythonApplication python3Packages.sbom2dot).overrideAttrs (previousAttrs: {
  meta.mainProgram = "sbom2dot";
})
