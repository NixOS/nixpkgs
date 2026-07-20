import ./generic.nix {
  version = "16.0.0";
  hash = "sha256-BZawFbrtcxftX4/Yk32aoVRQ6Kg+k1FhN9IoH6dxvVY=";
  npmDepsHash = "sha256-UhivpUqNJvc3zHxdRVAWT9x68jG1KnQa8yS4KkL2W5g=";
  vendorHash = "sha256-cb6f7ZX3pG95EEZotGXn6+YUJN59SFNVHFTejFJ6y28=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
