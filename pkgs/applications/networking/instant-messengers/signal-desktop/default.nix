{ stdenv, callPackage }:
{
  signal-desktop =
    if stdenv.hostPlatform.system == "aarch64-linux" then
      callPackage ./signal-desktop-aarch64.nix { }
    else if stdenv.hostPlatform.isDarwin then
      callPackage ./signal-desktop-darwin.nix { }
    else
      callPackage ./signal-desktop.nix { };
  signal-desktop-beta = (callPackage ./signal-desktop-beta.nix { }).overrideAttrs (old: {
    meta = old.meta // {
      platforms = [ "x86_64-linux" ];
    };
  });
}
