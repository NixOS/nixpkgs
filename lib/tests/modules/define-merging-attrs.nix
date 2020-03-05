{
  imports = [
    ./declare-attrs.nix
    { value = { foo = { bar = true; }; }; }
    { value = { foo = { bar = true; baz = 42; }; }; }
  ];
}
