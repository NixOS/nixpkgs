{ lib
, stdenv
, callPackage
}:

let
  pname = "plexamp";
  version = "4.8.2";
  meta = with lib; {
    description = "A beautiful Plex music player for audiophiles, curators, and hipsters";
    homepage = "https://plexamp.com/";
    changelog = "https://forums.plex.tv/t/plexamp-release-notes/221280/52";
    license = licenses.unfree;
    maintainers = with maintainers; [ killercup synthetica ];
    platforms = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
  };
in
if stdenv.isDarwin then callPackage ./darwin.nix { inherit pname version meta; }
else callPackage ./linux.nix { inherit pname version meta; }
