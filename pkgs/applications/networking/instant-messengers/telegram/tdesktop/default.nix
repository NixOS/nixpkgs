{ qt5 }:

let
  mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
  stableVersion = {
    stable = true;
    version = "1.4.3";
    sha256Hash = "1pvjvndqc7ylgc8ihf20fl1vb1x6fj7ywl6p1fr16j683vhdcml8";
    # svn log svn://svn.archlinux.org/community/telegram-desktop/trunk
    archPatchesRevision = "388730";
    archPatchesHash = "1gvisz36bc6bl4zcpjyyk0a2dl6ixp65an8wgm2lkc9mhkl783q7";
  };
in {
  stable = mkTelegram stableVersion;
  preview = mkTelegram (stableVersion // {
    version = "1.4.4";
    sha256Hash = "1m1j485r3vzpglzfn8l4cqskysvkx8l3pqaw3fgp66jfajbxynf0";
    stable = false;
  });
}
