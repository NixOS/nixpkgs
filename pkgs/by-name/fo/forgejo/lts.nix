import ./generic.nix {
  version = "11.0.3";
  hash = "sha256-tHanxcxpxVYKd28onKJnuB/Qtee2gop3yKjXJ+i9X4o=";
  npmDepsHash = "sha256-wsjosyZ5J5mU7ixbWjXnbqkvgnOE0dGz81vVqaI61go=";
  vendorHash = "sha256-5eaPdvU2NbCgbL+rcCqzphTESLHGbGZ3MgtXknCjrSc=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
