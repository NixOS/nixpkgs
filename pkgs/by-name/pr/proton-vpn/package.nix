{
  lib,
  stdenv,
  callPackage,
}:
let
  meta = {
    description = "Official Proton VPN client";
    homepage = "https://protonvpn.com/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      anthonyroussel
      delafthi
      rapiteanu
      sebtm
    ];
  };
in
if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix { inherit meta; }
else
  callPackage ./linux.nix { inherit meta; }
