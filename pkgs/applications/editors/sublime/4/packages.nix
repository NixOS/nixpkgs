{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
  {
    sublime4 = common {
      buildVersion = "4126";
      x64sha256 = "sha256-XGTlNMzgAy5U08cCjo1rO97yjz/SiiYkSjYKLOdUUKE=";
      aarch64sha256 = "0gmnxyczj2wk9dilhkpa6gi2fkvbic6smyiimd3lq0s7ilbarm0a";
    } {};

    sublime4-dev = common {
      buildVersion = "4136";
      dev = true;
      x64sha256 = "6cSaF8seS3XpXpoaROO5tpVuwJzE+z1kzwxNlOUadj0=";
      aarch64sha256 = "Mtib8i29FCFutRXmWPQSp9h/FcLD7+wv+tGAjwf9d3w=";
    } {};
  }
