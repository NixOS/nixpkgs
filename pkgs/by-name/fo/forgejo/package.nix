import ./generic.nix {
  version = "15.0.4";
  hash = "sha256-8AMq5CT4q7aaF5gj9d5+JINp5rrI5U98juI9BA0wVVo=";
  npmDepsHash = "sha256-BZSYjEsjUqMYWu3EUP+K35hqSOniv8Y6ek5bEC2vTPg=";
  vendorHash = "sha256-00QiJ8W76FdG96fmsIRLkaYlMQTZoIRmRd/qYGyPuig=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
