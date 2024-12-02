{ lib, callPackage, stdenvNoCC }:
let
  pname = "caprine";
  version = "2.59.1";
  metaCommon = with lib; {
    description = "Elegant Facebook Messenger desktop app";
    homepage = "https://sindresorhus.com/caprine";
    license = licenses.mit;
    maintainers = with maintainers; [ ShamrockLee ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
  x86_64-appimage = callPackage ./build-from-appimage.nix {
    inherit pname version metaCommon;
    sha256 = "sha256-stMv4KQoWPmK5jcfdhamC27Rb51zjbeEn40u6YUvXz4=";
  };
  x86_64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;
    sha256 = "sha256-WMT4yrLjDSMsI/lFbYODu3/0whcF+++4ShoChfMyLfQ=";
  };
in
(if stdenvNoCC.hostPlatform.isDarwin then x86_64-dmg else x86_64-appimage).overrideAttrs (oldAttrs: {
  passthru = (oldAttrs.passthru or { }) // { inherit x86_64-appimage x86_64-dmg; };
  meta = oldAttrs.meta // {
    platforms = x86_64-appimage.meta.platforms ++ x86_64-dmg.meta.platforms;
    mainProgram = "caprine";
  };
})
