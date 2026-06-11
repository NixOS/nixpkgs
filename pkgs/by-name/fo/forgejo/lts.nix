import ./generic.nix {
  version = "11.0.15";
  hash = "sha256-zClEFsf/DisvaDIFtHKLw4GXKpcGnmtR0XaSzKc+PdA=";
  npmDepsHash = "sha256-6tX/JCWJAYyboeRv5fb59wGnLTCdSYfGYDu0lJy5EQk=";
  vendorHash = "sha256-w49FOP3ZUbme0eZ+KPs6EVvDh9eljgghDND+xr+Pdkc=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
