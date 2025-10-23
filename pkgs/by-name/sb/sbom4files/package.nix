{
  python3Packages,
}:

(python3Packages.toPythonApplication python3Packages.sbom4files).overrideAttrs (previousAttrs: {
  meta.mainProgram = "sbom4files";
})
