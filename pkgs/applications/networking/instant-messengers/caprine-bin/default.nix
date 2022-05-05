{ lib, callPackage, stdenvNoCC }:
let
  pname = "caprine";
  version = "2.55.4";
  metaCommon = with lib; {
    description = "An elegant Facebook Messenger desktop app";
    homepage = "https://sindresorhus.com/caprine";
    license = licenses.mit;
    maintainers = with maintainers; [ ShamrockLee ];
  };
  x86_64-appimage = callPackage ./build-from-appimage.nix {
    inherit pname version metaCommon;
    sha256 = "221PyDoCkWqDdewCkFycpjMTcVOcl58blCjrC7O7xyk=";
  };
  x86_64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;
    sha256 = "6SOqlH7Z9DuQVR4i1OltnSb4dJscFUxaXxgNkE5FVUE=";
  };
in
(if stdenvNoCC.isDarwin then x86_64-dmg else x86_64-appimage).overrideAttrs (oldAttrs: {
  passthru = (oldAttrs.passthru or { }) // { inherit x86_64-appimage x86_64-dmg; };
  meta = oldAttrs.meta // {
    platforms = x86_64-appimage.meta.platforms ++ x86_64-dmg.meta.platforms;
  };
})
