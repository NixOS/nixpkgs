{
  fluffychat,
  ...
}@args:

fluffychat.override (
  {
    targetFlutterPlatform = "web";
  }
  // removeAttrs args [ "fluffychat" ]
)
