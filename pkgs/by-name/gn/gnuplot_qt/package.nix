{
  gnuplot,
  ...
}@args:

gnuplot.override (
  {
    withQt = true;
    withWxGTK = false; # Explicitly prevent dual-GUI bloat
  }
  // removeAttrs args [ "gnuplot" ]
)
