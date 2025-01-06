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
    buildVersion = "2101";
    dev = true;
    aarch64sha256 = "/56SBJ9ehoBCLTWYo8hGpn6/uqKxsSfcSzcJDd3uUMc=";
    x64sha256 = "AIH0VtEetiHdip0PIx1U1mcFlFz1gk0VCRDq4C5/wNM=";
  } { };
}
