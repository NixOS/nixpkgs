import ./generic.nix {
  version = "12.0.2";
  hash = "sha256-BkyzOrpwKkROKiZgSCr8Z7n8WO6qnkDyCBJ4HWO71Ws=";
  npmDepsHash = "sha256-kq2AV1D0xA4Csm8XUTU5D0iCmyuajcnwlLdPjJ/mj1g=";
  vendorHash = "sha256-B9menPCDUOYHPCS0B5KpxuE03FdFXmA8XqkiYEAxs5Y=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
