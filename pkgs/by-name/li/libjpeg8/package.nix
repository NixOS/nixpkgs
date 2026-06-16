{
  libjpeg_turbo,
  ...
}@args:

libjpeg_turbo.override (
  {
    enableJpeg8 = true;
  }
  // removeAttrs args [ "libjpeg_turbo" ]
)
