{
  libkrun,
  ...
}@args:

libkrun.override (
  {
    variant = "sev";
  }
  // removeAttrs args [ "libkrun" ]
)
