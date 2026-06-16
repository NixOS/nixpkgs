{
  pdfium-binaries,
  ...
}@args:

pdfium-binaries.override (
  {
    withV8 = true;
  }
  // removeAttrs args [ "pdfium-binaries" ]
)
