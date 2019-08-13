{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
  {
    sublime3-dev = common {
      buildVersion = "3208";
      dev = true;
      x32sha256 = "09k04fjryc0dc6173i6nwhi5xaan89n4lp0n083crvkqwp0qlf2i";
      x64sha256 = "12pn3yfm452m75dlyl0lyf82956j8raz2dglv328m81hbafflrj8";
    } {};

    sublime3 = common {
      buildVersion = "3207";
      x32sha256 = "14hfb8x8zb49zjq0pd8s73xk333gmf38h5b7g979czcmbhdxiyqy";
      x64sha256 = "1i1q9592sc8idvlpygksdkclh7h506hsz5l0i02g1814w0flzdmc";
    } {};
  }
