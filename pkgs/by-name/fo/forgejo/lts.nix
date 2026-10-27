import ./generic.nix {
  version = "15.0.11";
  hash = "sha256-Y7bJri8fu16ETNxvo21t1kAtomeXZcsd1nV6ATBQBvE=";
  npmDepsHash = "sha256-B8npL45uJlj6oD6C/MYsu1KRyT9UgOYp1Jg9/xZRqtQ=";
  vendorHash = "sha256-tIQmzsPVf5Ka3LmJJxlju750Ja1BKN3JX+8HRyjze+0=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
