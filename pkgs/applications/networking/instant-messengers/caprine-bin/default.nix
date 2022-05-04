{ lib, callPackage, stdenvNoCC }:
let
  pname = "caprine";
  version = "2.55.2";
  metaCommon = with lib; {
    description = "An elegant Facebook Messenger desktop app";
    homepage = "https://sindresorhus.com/caprine";
    license = licenses.mit;
    maintainers = with maintainers; [ ShamrockLee ];
  };
  x86_64-appimage = callPackage ./build-from-appimage.nix {
    inherit pname version metaCommon;
    sha256 = "J7eHVXjWSIcTpLMM8FlGKZzVh6XgpQ0d82kxfMbPyZ4=";
  };
  x86_64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;
    sha256 = "du/9N1BFq1s7spPiEDgDbjjcnkA0x1ExhAEpQvmO3aA=";
  };
in
(if stdenvNoCC.isDarwin then x86_64-dmg else x86_64-appimage).overrideAttrs (oldAttrs: {
  passthru = (oldAttrs.passthru or { }) // { inherit x86_64-appimage x86_64-dmg; };
  meta = oldAttrs.meta // {
    platforms = x86_64-appimage.meta.platforms ++ x86_64-dmg.meta.platforms;
  };
})
