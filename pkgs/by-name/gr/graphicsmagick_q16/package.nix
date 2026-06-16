{
  graphicsmagick,
  ...
}@args:

graphicsmagick.override (
  {
    quantumdepth = 16;
  }
  // removeAttrs args [ "graphicsmagick" ]
)
