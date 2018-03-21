{ qt5, stdenv }:

let mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
in {
  stable = mkTelegram {
    stable = true;
    version = "1.2.6";
    sha256Hash = "15g0m2wwqfp13wd7j31p8cx1kpylx5m8ljaksnsqdkgyr9l1ar8w";
    # svn log svn://svn.archlinux.org/community/telegram-desktop/trunk
    archPatchesRevision = "283641";
    archPatchesHash = "0v4213vrabfa2dmwnqgb8n6hl54938mw9glaim3amyslxphmdrfb";
  };
  preview = mkTelegram {
    stable = false;
    version = "1.2.12";
    sha256Hash = "1b9qc4a14jqjl30z4bjh1zbqsmgl25kdp0hj8p7xbj34zlkzfw5m";
    # svn ls -v --depth empty svn://svn.archlinux.org/community/telegram-desktop/trunk
    archPatchesRevision = "308775";
    archPatchesHash = "0ggx64kdadrbd4bw5z0wi0fdg6hni7n9nxz9dp56p8hlw1wgpsls";
  };
}
