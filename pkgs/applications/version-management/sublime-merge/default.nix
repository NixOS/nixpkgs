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
    buildVersion = "2100";
    dev = true;
    aarch64sha256 = "BL0hk/8hf660I1HUQMQwvZxB6TpXpygQxOYtuDGfrYw=";
    x64sha256 = "NePJt2WttsbqJsduGX6UsOzAce2xW4Mc8Nq9We+ZCSM=";
  } { };
}
