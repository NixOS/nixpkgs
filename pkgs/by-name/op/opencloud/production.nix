import ./generic.nix {
  version = "7.2.5";
  production = true;
  hash = "sha256-52Zhe+dXxzOxJxIzlf1vULFFeGOl7KyybKdQwljQQvs=";
  webVersion = "7.1.6";
  webHash = "sha256-RFStrBPro9+lAPDrCp7bcyBbEk3GZBuNtuwmq63aJuw=";
  webPnpmDepsHash = "sha256-YEdZ5B11I6U140qam7e1TMOacRqUeINhr/TI13ddAa0=";
  idpWebPnpmDepsHash = "sha256-pQ01vBvC29B5oxDWtt7anI5QtFbvQFFBVamQtA2WTNo=";
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/op/opencloud/production.nix"
  ];
}
