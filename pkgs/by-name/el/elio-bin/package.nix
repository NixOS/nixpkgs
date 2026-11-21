{
  lib,
  stdenv,
  callPackage,
}:
let
  pname = "elio-bin";
  version = "1.11.2";

  meta = {
    description = "Snappy, batteries-included terminal file manager with rich previews, inline images, bulk actions, and trash support";
    homepage = "https://github.com/elio-fm/elio";
    changelog = "https://github.com/elio-fm/elio/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "elio";
    maintainers = with lib.maintainers; [
      caliguIa
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
in
if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix {
    inherit
      pname
      version
      meta
      ;
  }
else if stdenv.hostPlatform.isLinux then
  callPackage ./linux.nix {
    inherit
      pname
      version
      meta
      ;
  }
else
  throw "Unsupported platform: ${stdenv.hostPlatform.system}"
