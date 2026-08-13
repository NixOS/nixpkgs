{
  mkPrelude,
  prelude,
  base,
}:
mkPrelude {
  name = "linear";
  dependencies = [
    prelude
    base
  ];
}
