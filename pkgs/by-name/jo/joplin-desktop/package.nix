{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
  makeWrapper,
  _7zz,
}:

let
  pname = "joplin-desktop";
  inherit (releaseData) version;

  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  releaseData = lib.importJSON ./release-data.json;
  src = fetchurl releaseData.${system} or throwSystem;

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

  meta = with lib; {
    description = "Open source note taking and to-do application with synchronisation capabilities";
    mainProgram = "joplin-desktop";
    longDescription = ''
      Joplin is a free, open source note taking and to-do application, which can
      handle a large number of notes organised into notebooks. The notes are
      searchable, can be copied, tagged and modified either from the
      applications directly or from your own text editor. The notes are in
      Markdown format.
    '';
    homepage = "https://joplinapp.org";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
      hugoreeves
      qjoly
      yajo
    ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };

  linux = appimageTools.wrapType2 {
    inherit
      pname
      version
      src
      meta
      ;
    nativeBuildInputs = [ makeWrapper ];

    profile = ''
      export LC_ALL=C.UTF-8
    '';

    extraInstallCommands = ''
      wrapProgram $out/bin/joplin-desktop \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations}}"
      install -Dm644 ${appimageContents}/joplin.desktop $out/share/applications/joplin.desktop
      install -Dm644 ${appimageContents}/joplin.png $out/share/pixmaps/joplin.png
      substituteInPlace $out/share/applications/joplin.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=joplin-desktop'
    '';

    passthru.updateScript = ./update.py;
  };

  darwin = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    nativeBuildInputs = [ _7zz ];

    unpackPhase = ''
      runHook preUnpack
      7zz x -x'!Joplin ${version}/Applications' -xr'!*:com.apple.cs.Code*' $src
      runHook postUnpack
    '';

    sourceRoot = if stdenv.hostPlatform.isx86_64 then "Joplin ${version}" else ".";

    postPatch = ''
      chmod a+x Joplin.app/Contents/Resources/build/7zip/7za
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications
      cp -R Joplin.app $out/Applications
      runHook postInstall
    '';

    passthru.updateScript = ./update.py;
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
