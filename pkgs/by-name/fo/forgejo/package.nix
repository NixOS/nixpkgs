import ./generic.nix {
  version = "15.0.3";
  hash = "sha256-tGZ83TEG6iyZd5mfSuSvVkmUJINWLN661YpOk1+dgbM=";
  npmDepsHash = "sha256-BZSYjEsjUqMYWu3EUP+K35hqSOniv8Y6ek5bEC2vTPg=";
  vendorHash = "sha256-z3YTjt+SM9yPCsJdfSQbTpy3vRiXaFV2QMz1y6J6k/Q=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
