{
  lib,
  stdenv,
  callPackage,
}:

let
  pname = "rssguard";
  version = "4.8.1";

  meta = with lib; {
    description = "Simple RSS/Atom feed reader with online synchronization";
    mainProgram = "rssguard";
    longDescription = ''
      RSS Guard is a simple, light and easy-to-use RSS/ATOM feed aggregator
      developed using Qt framework and with online feed synchronization support
      for ownCloud/Nextcloud.
    '';
    homepage = "https://github.com/martinrotter/rssguard";
    changelog = "https://github.com/martinrotter/rssguard/releases/tag/${version}";
    license = licenses.gpl3Plus;
    platforms = platforms.darwin ++ platforms.linux;
    maintainers = with maintainers; [
      jluttine
      tebriel
    ];
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
else
  callPackage ./linux.nix { inherit pname version meta; }
