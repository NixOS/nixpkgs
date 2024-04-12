{ lib
, stdenv
, callPackage
, ...
}@args:

let
  extraArgs = removeAttrs args [ "callPackage" ];

  pname = "bitwarden-desktop";

  meta = {
    description = "A secure and free password manager for all of your devices";
    homepage = "https://bitwarden.com";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ amarshall kiwi ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "bitwarden";
  };
in
  callPackage ./linux.nix (extraArgs // { inherit pname meta; })
