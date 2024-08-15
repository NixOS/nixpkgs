{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
{
  sublime-merge = common {
    buildVersion = "2096";
    aarch64sha256 = "IHPJJ/oQ3SLemRyey5syTL0sf5GEeHSylDX+EQNNQGU=";
    x64sha256 = "41I6p5wNx2pF56np7gHqp396RHpXtQu5ruksUywF/Ug=";
  } { };

  sublime-merge-dev = common {
    buildVersion = "2099";
    dev = true;
    aarch64sha256 = "6rfUwzSBCJ3CRrL5E4+wBQ3FuB3PaAUCwh5pDtAbNKE=";
    x64sha256 = "qIXDlsdaxY8wvky/ClwhZykZTVrUShsV56utb6BRCWQ=";
  } { };
}
