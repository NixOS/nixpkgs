{
  jackmix,
  jack1,
  ...
}@args:

jackmix.override (
  {
    jack = jack1;
  }
  // removeAttrs args [
    "jackmix"
    "jack1"
  ]
)
