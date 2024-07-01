{
  stdenv,
  lib,
  callPackage,
}:
let
  pname = "miru";
  version = "5.1.6";
  meta = with lib; {
    description = "Stream anime torrents, real-time with no waiting for downloads";
    homepage = "https://miru.watch";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      d4ilyrun
      matteopacini
    ];
    mainProgram = "miru";

    platforms = [ "x86_64-linux" ] ++ platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];

    longDescription = ''
      A pure JS BitTorrent streaming environment, with a built-in list manager.
      Imagine qBit + Taiga + MPV, all in a single package, but streamed real-time.
      Completely ad free with no tracking/data collection.

      This app is meant to feel look, work and perform like a streaming website/app,
      while providing all the advantages of torrenting, like file downloads,
      higher download speeds, better video quality and quicker releases.

      Unlike qBit's sequential, seeking into undownloaded data will prioritise downloading that data,
      instead of flat out closing MPV.
    '';
  };
in
if stdenv.isDarwin then
  callPackage ./darwin.nix { inherit pname version meta; }
else
  callPackage ./linux.nix { inherit pname version meta; }
