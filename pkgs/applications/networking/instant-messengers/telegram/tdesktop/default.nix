{ qt5 }:

let
  mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
  stableVersion = {
    stable = true;
    version = "1.7.0";
    sha256Hash = "1plfby243hf65wjmppq1qnqmp25pgi4x3awqd4h83ly9hn8qdwfk";
    # svn log svn://svn.archlinux.org/community/telegram-desktop/trunk
    archPatchesRevision = "464796";
    archPatchesHash = "1bq7r69k3i9p1csdsca0w41jyz6fbyn4qriv3lg7s28j9s803kw8";
  };
in {
  stable = mkTelegram stableVersion;
  preview = mkTelegram (stableVersion // {
    stable = false;
  });
}
