{ qt5 }:

let
  mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
  stableVersion = {
    stable = true;
    version = "1.7.14";
    sha256Hash = "1bw804a9kffmn23wv0570wihbvfm7jy9cqmxlv196f4j7bw7zkv3";
    # svn log svn://svn.archlinux.org/community/telegram-desktop/trunk
    archPatchesRevision = "487779";
    archPatchesHash = "0f09hvimb66xqksb2v0zc4ryshx7y7z0rafzjd99x37rpib9f3kq";
  };
in {
  stable = mkTelegram stableVersion;
  preview = mkTelegram (stableVersion // {
    stable = false;
  });
}
