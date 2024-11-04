import ./generic.nix {
  version = "7.0.10";
  hash = "sha256-shPrbWuNmoSYXcL0QcgNjapdoWnO3/2h6eUFdMnteR4=";
  npmDepsHash = "sha256-RR1FVbyXgeXAWkNYjgleAE7hPqVur00bO1jF3WhGYKA=";
  vendorHash = "sha256-hfbNyCQMQzDzJxFc2MPAR4+v/qNcnORiQNbwbbIA4Nw=";
  lts = true;
  nixUpdateExtraArgs = [
    "--version-regex"
    "v(7\.[0-9.]+)"
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
