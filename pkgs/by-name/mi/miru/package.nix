{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 rec {
  pname = "miru";
  version = "5.1.0";

  src = fetchurl {
    url = "https://github.com/ThaUnknown/miru/releases/download/v${version}/linux-Miru-${version}.AppImage";
    name = "${pname}-${version}.AppImage";
    sha256 = "sha256-N9I5YNFIfBmANCnJA3gUmgq04cc5LLfOsYiEdwJupf8=";
  };

  extraInstallCommands =
    let
      contents = appimageTools.extractType2 { inherit pname version src; };
    in
    ''
      mkdir -p "$out/share/applications"
      mkdir -p "$out/share/lib/miru"
      cp -r ${contents}/{locales,resources} "$out/share/lib/miru"
      cp -r ${contents}/usr/* "$out"
      cp "${contents}/${pname}.desktop" "$out/share/applications/"
      substituteInPlace $out/share/applications/${pname}.desktop --replace 'Exec=AppRun' 'Exec=${pname}'
    '';

  meta = with lib; {
    description = "Stream anime torrents, real-time with no waiting for downloads";
    homepage = "https://miru.watch";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.d4ilyrun ];
    mainProgram = "miru";

    platforms = [ "x86_64-linux" ];
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
}
