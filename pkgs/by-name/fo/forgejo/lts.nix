import ./generic.nix {
  version = "7.0.9";
  hash = "sha256-JoHF49n2HWMHl/LMWxQlj7utkmzyZ5pHEfeSU8gjyfU=";
  npmDepsHash = "sha256-9U2I+JzDGQlfjyvZRbfPbDMmoHxIJ/SOBhMdn1la0EI=";
  vendorHash = "sha256-hfbNyCQMQzDzJxFc2MPAR4+v/qNcnORiQNbwbbIA4Nw=";
  lts = true;
  nixUpdateExtraArgs = [
    "--version-regex"
    "v(7\.[0-9.]+)"
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
