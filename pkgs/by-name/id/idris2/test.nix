{
  mkPrelude,
  prelude,
  base,
  contrib,
}:
mkPrelude {
  name = "test";
  dependencies = [
    prelude
    base
    contrib
  ];
}
