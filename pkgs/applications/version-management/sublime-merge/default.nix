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
    buildVersion = "2095";
    dev = true;
    aarch64sha256 = "FmXz8VAWS7e0bB9NeXbihnhdhWMyNJJs6PNt+K2G0Bk=";
    x64sha256 = "83Hw27RgGPgugpf4eMuWT6/MSQ2Q2VBCbaXoSGFtTPI=";
  } { };
}
