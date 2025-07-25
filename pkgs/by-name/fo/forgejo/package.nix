import ./generic.nix {
  version = "12.0.0";
  hash = "sha256-8cokjK9fbxd9lm+5oDoMll9f7ejiVzMNuDgC0Pk1pbM=";
  npmDepsHash = "sha256-kq2AV1D0xA4Csm8XUTU5D0iCmyuajcnwlLdPjJ/mj1g=";
  vendorHash = "sha256-B9menPCDUOYHPCS0B5KpxuE03FdFXmA8XqkiYEAxs5Y=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
