import ./generic.nix {
  hash = "sha256-S6PTtgP4MFV+kiEgV8PBvek1SrVjLaCR9OJy/6jqJGE=";
  version = "6.11.0";
  vendorHash = "sha256-wKL+woCMjGJwCBG/JBhFbY4uc97/5K7OWPZRp0J+5DQ=";
  patches = [ ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
