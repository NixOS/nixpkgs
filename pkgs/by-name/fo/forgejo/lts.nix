import ./generic.nix {
  version = "15.0.5";
  hash = "sha256-S+x/YEfQrYIzHLnZ7LDLnkMYVN3TajwS7SHydM8uMPQ=";
  npmDepsHash = "sha256-BZSYjEsjUqMYWu3EUP+K35hqSOniv8Y6ek5bEC2vTPg=";
  vendorHash = "sha256-00QiJ8W76FdG96fmsIRLkaYlMQTZoIRmRd/qYGyPuig=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
