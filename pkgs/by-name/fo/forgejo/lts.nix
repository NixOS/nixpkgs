import ./generic.nix {
  version = "11.0.14";
  hash = "sha256-rFF+naEEvTj1UqcX8Y2UTHGcBdM8mGgZWJgcC69jdxQ=";
  npmDepsHash = "sha256-B5ndsIk9Jntu7f7w6NrsBxfFSxhYFeq1NfXTtzckklw=";
  vendorHash = "sha256-bdp3Qy/09qa/bwPUIDmdrJXma39zdgovIZqENo+AVyY=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
