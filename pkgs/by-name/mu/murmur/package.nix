{
  mumble,
  config,
  iceSupport ? config.murmur.iceSupport or true,
}@args:

mumble.override (
  {
    type = "murmur";
    inherit iceSupport;
  }
  // removeAttrs args [ "mumble" ]
)
