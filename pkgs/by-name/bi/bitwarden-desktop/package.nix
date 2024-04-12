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
    sourceProvenance = with lib.sourceTypes; if stdenv.isDarwin then [ binaryNativeCode ] else [ fromSource ];
    platforms = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
    mainProgram = "bitwarden";
  };
in if stdenv.isDarwin then
  callPackage ./darwin.nix (extraArgs // { inherit pname meta; })
else
  callPackage ./linux.nix (extraArgs // { inherit pname meta; })
