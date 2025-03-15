{
  stdenv,
  callPackage,
  withUnfree ? false,
}:
if stdenv.hostPlatform.system == "aarch64-linux" then
  if !withUnfree then
    callPackage ./signal-desktop-aarch64.nix { }
  else
    callPackage ./signal-desktop-aarch64-apple-emoji.nix { }
else if stdenv.hostPlatform.isDarwin then
  callPackage ./signal-desktop-darwin.nix { }
else if !withUnfree then
  callPackage ./signal-desktop.nix { }
else
  callPackage ./signal-desktop-apple-emoji.nix { }
