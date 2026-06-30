{
  mumble,
  iceSupport ? true,
}@args:

mumble.override (
  {
    type = "murmur";
    inherit iceSupport;
  }
  // removeAttrs args [ "mumble" ]
)
