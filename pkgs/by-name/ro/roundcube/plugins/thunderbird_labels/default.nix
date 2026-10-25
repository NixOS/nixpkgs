{ roundcubePlugin, fetchzip }:

roundcubePlugin rec {
  pname = "thunderbird_labels";
  version = "1.6.2";

  src = fetchzip {
    url = "https://github.com/mike-kfed/roundcube-thunderbird_labels/archive/refs/tags/v${version}.tar.gz";
    hash = "sha256-i06kfA9oxRX+tICTPWBobOyHedqbjBb4JLBmC9ruBmM=";
  };
}
