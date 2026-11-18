import ./generic.nix {
  version = "9.1.0";
  production = false;
  hash = "sha256-AZr4JB6PmCx1jqYzzETU/QgTMlDcmu31KQEhDzZbW8s=";
  webVersion = "8.2.2";
  webHash = "sha256-HyuHWi4G39MN6rQpqbduCbcmKqOQhMHpxKzwn2XpEM8=";
  webPnpmDepsHash = "sha256-n6zv/QpZw81qDrFP/QmU3VTf+zbX0Vn2SpemB1MvfNA=";
  idpWebPnpmDepsHash = "sha256-k6CzXQuUMXWiUnviljRx1u1ApmORRZhdlUQBlgMh02I=";
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/op/opencloud/package.nix"
  ];
}
