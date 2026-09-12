{
  groff,
}@args:

groff.override (
  {
    enableGhostscript = true;
    enableHtml = true;
    enableIconv = true;
    enableLibuchardet = true;
    enableUrwFonts = true;
  }
  // removeAttrs args [ "groff" ]
)
