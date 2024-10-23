{ hostPlatform, callPackage }:
{
  signal-desktop = callPackage (
    {
      withUnfree ? false,
    }:
    if hostPlatform.system == "aarch64-linux" then
      if !withUnfree then
        callPackage ./signal-desktop-aarch64.nix { }
      else
        callPackage ./signal-desktop-aarch64-apple-emoji.nix { }
    else if hostPlatform.isDarwin then
      callPackage ./signal-desktop-darwin.nix { }
    else if !withUnfree then
      callPackage ./signal-desktop.nix { }
    else
      callPackage ./signal-desktop-apple-emoji.nix { }
  ) { };
  signal-desktop-beta =
    (callPackage (
      {
        withUnfree ? false,
      }:
      if !withUnfree then
        callPackage ./signal-desktop-beta.nix { }
      else
        callPackage ./signal-desktop-beta-apple-emoji.nix { }
    ) { }).overrideAttrs
      (old: {
        meta = old.meta // {
          platforms = [ "x86_64-linux" ];
        };
      });
}
