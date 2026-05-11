{
  mkPrelude,
  prelude,
  base,
  linear,
}:
mkPrelude {
  name = "network";
  dependencies = [
    prelude
    base
    linear
  ];
}
