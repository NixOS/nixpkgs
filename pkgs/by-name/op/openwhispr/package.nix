{
  lib,
  appimageTools,
  fetchurl,
  runCommand,
}:

let
  pname = "openwhispr";
  version = "1.7.0";

  src = fetchurl {
    url = "https://github.com/OpenWhispr/openwhispr/releases/download/v${version}/OpenWhispr-${version}-linux-x86_64.AppImage";
    hash = "sha256-Fugr2nrIkSHwnDZVwtV+CWwZ50PbI0Amrm1VXFcW6K4=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

  # Start Electron from the extracted app dir so utilityProcess worker imports
  # resolve against the packaged resources instead of the caller's cwd.
  patchedAppimageContents = runCommand "${pname}-${version}-patched-appdir" { } ''
        cp -r ${appimageContents} $out
        chmod -R u+w $out

        # Removing linux-fast-paste to use the ydtool fallback because of the primary method beeing defect on at least GNOME Wayland
        rm -f $out/resources/bin/linux-fast-paste

        substituteInPlace $out/open-whispr \
          --replace-fail 'exec -a "$0" "$HERE/open-whispr-app" "''${FLAGS[@]}" "$@"' \
                         'cd "$HERE"
    exec -a "$0" "$HERE/open-whispr-app" "''${FLAGS[@]}" "$@"'
  '';
in
(appimageTools.wrapAppImage {
  inherit pname version;
  src = patchedAppimageContents;

  extraPkgs =
    pkgs: with pkgs; [
      unzip
    ];

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/open-whispr.desktop -t $out/share/applications
    install -Dm444 ${appimageContents}/usr/share/icons/hicolor/256x256/apps/open-whispr.png \
      -t $out/share/icons/hicolor/256x256/apps

    substituteInPlace $out/share/applications/open-whispr.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=${pname} %U'
  '';

  meta = {
    description = "Privacy-first desktop voice dictation, meeting transcription, and notes app";
    longDescription = ''
      OpenWhispr is a cross-platform desktop application for voice dictation,
      meeting transcription, notes, and AI-assisted actions.
    '';
    homepage = "https://github.com/OpenWhispr/openwhispr";
    changelog = "https://github.com/OpenWhispr/openwhispr/releases/tag/v${version}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "openwhispr";
    maintainers = with lib.maintainers; [ benediktweyer ];
    platforms = [ "x86_64-linux" ];
  };
}).overrideAttrs
  {
    strictDeps = true;
    __structuredAttrs = true;
  }
