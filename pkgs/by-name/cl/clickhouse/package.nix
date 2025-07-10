import ./generic.nix {
  version = "25.6.3.116-stable";
  hash = "sha256-gWvlVhW9RtSj50+Mzlvk0aTNdl0hS9vHzveocTvuazc=";
  lts = false;
  nixUpdateExtraArgs = [
    "--version-regex"
    "^v?(.*-stable)$"
    "--override-filename"
    "pkgs/by-name/cl/clickhouse/package.nix"
  ];
}
