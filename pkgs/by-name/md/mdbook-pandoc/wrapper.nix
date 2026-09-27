{
  mdbook-pandoc,
  pandoc,
  symlinkJoin,
}:

symlinkJoin {
  name = "mdbook-pandoc-wrapped-${mdbook-pandoc.version}";

  paths = [
    mdbook-pandoc
    pandoc
  ];
}
