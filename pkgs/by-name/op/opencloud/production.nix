import ./generic.nix {
  version = "7.2.4";
  production = true;
  hash = "sha256-X/4m5inB1cPRbUtolOk5sGUuK940GxEf6eVLUIngijQ=";
  webVersion = "7.1.5";
  webHash = "sha256-nTjFR9VZuP1w1dXvStMv7/6hV+V9FUKWjUGse1tdCFE=";
  webPnpmDepsHash = "sha256-YEdZ5B11I6U140qam7e1TMOacRqUeINhr/TI13ddAa0=";
  idpWebPnpmDepsHash = "sha256-pQ01vBvC29B5oxDWtt7anI5QtFbvQFFBVamQtA2WTNo=";
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/op/opencloud/production.nix"
  ];
}
