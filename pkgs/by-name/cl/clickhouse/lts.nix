import ./generic.nix {
  version = "25.3.5.42-lts";
  hash = "sha256-LvGl9XJK6Emt7HnV/Orp7qEmJSr3TBJZtApL6GrWIMg=";
  lts = true;
  nixUpdateExtraArgs = [
    "--version-regex"
    "^v?(.*-lts)$"
    "--override-filename"
    "pkgs/by-name/cl/clickhouse/lts.nix"
  ];
}
