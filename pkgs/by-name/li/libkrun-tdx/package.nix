{
  libkrun,
  ...
}@args:

libkrun.override (
  {
    variant = "tdx";
  }
  // removeAttrs args [ "libkrun" ]
)
