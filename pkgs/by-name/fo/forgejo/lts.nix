import ./generic.nix {
  version = "15.0.7";
  hash = "sha256-RzrOnnxHUKWfiQnF2TSDkMa2AZfqBhWVAjw26/B3ZgM=";
  npmDepsHash = "sha256-VFkOYYznOXXis8mE4njTcLbh36AnW4wQgMLcvyCTSKY=";
  vendorHash = "sha256-7KqezBwhcbOhX426HTOcOOIzscuqWJLmkgpMYuBRVr8=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
