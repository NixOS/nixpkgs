import ./generic.nix {
  version = "11.0.13";
  hash = "sha256-bXJ4ddUKTGKRWagL1G71sasMghr5FdiZPtHjrOTpxDY=";
  npmDepsHash = "sha256-ZAcv/EnCx8dikjW9wgQBNln9WUQOkw0RCLVRoDPY8Gc=";
  vendorHash = "sha256-0oh1zhMRz8B5TInAuuvYg63noxSAoupSQvQeerO3TFI=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
