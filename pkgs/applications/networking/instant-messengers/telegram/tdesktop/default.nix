{ qt5 }:

let
  mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
  stableVersion = {
    stable = true;
    version = "1.5.9";
    sha256Hash = "1mq0fj29fbn8lk7jhj8gzjvqg2q1hi0hvfwfk1a5qiib0x31gfic";
    # svn log svn://svn.archlinux.org/community/telegram-desktop/trunk
    archPatchesRevision = "428981";
    archPatchesHash = "1r58yjqdv3wgyhb391dblvij67girdwf4ggcw1lsq587sykx51yk";
  };
in {
  stable = mkTelegram stableVersion;
  preview = mkTelegram (stableVersion // {
    stable = false;
  });
}
