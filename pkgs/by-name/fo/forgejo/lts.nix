import ./generic.nix {
  version = "11.0.12";
  hash = "sha256-akPRq8quzdx8TU8NC/uxvngEl/fl/JjM1FcVhlHxcXo=";
  npmDepsHash = "sha256-2COWPQM1iKpNG2TbPIv2zXXe28tsmuVc6IhkUeORBsU=";
  vendorHash = "sha256-v1UZwhgZglJvIkEfO7662lKhdO3AxH+DGN70ziWfXG0=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
