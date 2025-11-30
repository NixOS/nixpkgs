{
  stdenvNoCC,
  fetchurl,
  lib,
  nix-update-script,
  callPackage,
}:
let
  pname = "hayase";
  version = "6.4.38";
  src =
    if stdenvNoCC.hostPlatform.isDarwin then
      fetchurl {
        url = "https://github.com/hayase-app/docs/releases/download/v${version}/mac-hayase-${version}-mac.dmg";
        hash = "sha256-B2gAM2zPCBpsLCct/FND5wP7V/sbE+T171qze1teM5o=";
      }
    else
      fetchurl {
        url = "https://github.com/hayase-app/docs/releases/download/v${version}/linux-hayase-${version}-linux.AppImage";
        hash = "sha256-Pu8Orfeiwd9QJFHgIa119WR/45cND64asz9KjU11W+k=";
      };
  meta = {
    description = "Stream anime torrents instantly, real-time with no waiting for downloads to finish! 🍿";
    homepage = "https://hayase.watch/";
    license = lib.licenses.bsl11;
    maintainers = [ lib.maintainers.juliuskreutz ];
    platforms = [ "x86_64-linux" ] ++ lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "hayase";
  };
  passthru.updateScript = nix-update-script { };
in
if stdenvNoCC.hostPlatform.isDarwin then
  callPackage ./darwin.nix {
    inherit
      pname
      version
      src
      meta
      passthru
      ;
  }
else
  callPackage ./linux.nix {
    inherit
      pname
      version
      src
      meta
      passthru
      ;
  }
