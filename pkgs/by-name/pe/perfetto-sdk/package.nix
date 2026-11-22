{
  perfetto,
  ...
}@args:

# Alias to perfetto.sdk to improve discoverability
(perfetto.override (removeAttrs args [ "perfetto" ])).sdk
