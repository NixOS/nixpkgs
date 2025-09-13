{
  python3Packages,
}:
(python3Packages.toPythonApplication python3Packages.fio_plot).overrideAttrs (old: {
  meta = old.meta // {
    mainProgram = "fio-plot";
  };
})
