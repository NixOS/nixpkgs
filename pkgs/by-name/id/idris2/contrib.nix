{
  mkPrelude,
  prelude,
  base,
}:
mkPrelude {
  name = "contrib";
  dependencies = [
    prelude
    base
  ];
}
