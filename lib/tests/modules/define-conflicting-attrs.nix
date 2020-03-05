{
  imports = [
    ./declare-attrs.nix
    { value = { foo = { bar = false; }; }; }
    { value = { foo = { bar = true; }; }; }
  ];
}
