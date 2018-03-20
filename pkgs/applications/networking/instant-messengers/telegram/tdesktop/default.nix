{ qt5, stdenv }:

let mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
in {
  stable = mkTelegram {
    stable = true;
    version = "1.2.6";
    sha256Hash = "15g0m2wwqfp13wd7j31p8cx1kpylx5m8ljaksnsqdkgyr9l1ar8w";
  };
  preview = mkTelegram {
    stable = false;
    version = "1.2.12";
    sha256Hash = "1b9qc4a14jqjl30z4bjh1zbqsmgl25kdp0hj8p7xbj34zlkzfw5m";
  };
}
