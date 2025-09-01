import ./generic.nix {
  version = "11.0.4";
  hash = "sha256-RI6eCJx1QTDkzY1oFKwCQyOrRXMd0TFihWofC4ZCv44=";
  npmDepsHash = "sha256-wsjosyZ5J5mU7ixbWjXnbqkvgnOE0dGz81vVqaI61go=";
  vendorHash = "sha256-Zfjp6EKiO74wYgvc85AwtDg+3Nf7lEa1ZKQMMcYPM34=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
