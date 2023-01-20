{ callPackage, stdenvNoCC, lib }:
let
  version = "3.43.0";
  appimage = callPackage ./appimage.nix { inherit version; sha256 = "1xfr3i4gsi13wj374yr5idhgs0q71s4h33yxdr7b7xjdg2gb8lp1"; };
  dmg = callPackage ./dmg.nix { inherit version; sha256 = "1axki47hrxx5m0hrmjpxcya091lahqfnh2pd3zhn5dd496slq8an"; };
  windows = callPackage ./windows.nix { inherit version; sha256 = "1v00gym18hjxxm42dfqmw7vhwh8lgjz2jgv6fmg234npr3d43py5"; };
in (
  if stdenvNoCC.isDarwin then dmg
  else if stdenvNoCC.isCygwin then windows
  else appimage
).overrideAttrs
(oldAttrs: {
  meta = with lib; {
    description = "The swiss army knife of lossless video/audio editing";
    homepage = "https://mifi.no/losslesscut/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ShamrockLee ];
  } // oldAttrs.meta // {
    platforms =
      appimage.meta.platforms
      ++ dmg.meta.platforms
      ++ windows.meta.platforms;
  };
})
