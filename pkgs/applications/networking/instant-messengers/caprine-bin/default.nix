{ lib, callPackage, stdenvNoCC }:
let
  pname = "caprine";
  version = "2.58.3";
  metaCommon = with lib; {
    description = "An elegant Facebook Messenger desktop app";
    homepage = "https://sindresorhus.com/caprine";
    license = licenses.mit;
    maintainers = with maintainers; [ ShamrockLee ];
  };
  x86_64-appimage = callPackage ./build-from-appimage.nix {
    inherit pname version metaCommon;
    sha256 = "sha256-w0nBQhHYzFLsNu0MxWhoju6fh4JpAKC7MWWVxwDkRYk=";
  };
  x86_64-dmg = callPackage ./build-from-dmg.nix {
    inherit pname version metaCommon;
    sha256 = "sha256-6Mx2ZkT2hdnaSVt2hKMMV9xc7rYPFFbxcj6vb84ojYU=";
  };
in
(if stdenvNoCC.isDarwin then x86_64-dmg else x86_64-appimage).overrideAttrs (oldAttrs: {
  passthru = (oldAttrs.passthru or { }) // { inherit x86_64-appimage x86_64-dmg; };
  meta = oldAttrs.meta // {
    platforms = x86_64-appimage.meta.platforms ++ x86_64-dmg.meta.platforms;
    mainProgram = "caprine";
  };
})
