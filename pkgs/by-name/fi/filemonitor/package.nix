{
  lib,
  stdenvNoCC,
  fetchzip,
  makeWrapper,
  writeShellApplication,
  testers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "filemonitor";
  version = "1.3.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchzip {
    url = "https://bitbucket.org/objective-see/deploy/downloads/FileMonitor_${finalAttrs.version}.zip";
    hash = "sha256-ycC2MySfsnW6JicQRlWtuAqI887+0TlnD6PtlWewuog=";

    stripRoot = false;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R FileMonitor.app $out/Applications/

    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/bin
    makeWrapper $out/Applications/FileMonitor.app/Contents/MacOS/FileMonitor $out/bin/${finalAttrs.pname}
  '';

  passthru = {
    updateScript = lib.getExe (writeShellApplication {
      name = "update-filemonitor";
      text = ''
        latest_version=$(curl -s https://objective-see.org/products/changelogs/FileMonitor.txt | grep -m1 -oE '[0-9]+\.[0-9]+\.[0-9]+')
        update-source-version ${finalAttrs.pname} "$latest_version"
      '';
    });

    tests = {
      help = testers.runCommand {
        name = "filemonitor-help-test";
        buildInputs = [ finalAttrs.finalPackage ];
        script = ''
          # Capture both stdout and stderr, and use `|| true` to suppress the 255 exit code
          # which occurs because of the wrong help exit code imlementation in filemonitor
          # Fix when this is merged: https://github.com/objective-see/FileMonitor/pull/14
          output=$(filemonitor -h 2>&1 || true)

          echo "$output" | grep -F "FileMonitor (v${finalAttrs.version})"

          touch $out
        '';
      };
    };
  };

  meta = {
    mainProgram = "filemonitor";
    description = "Advanced utility that monitors file events on macOS";
    longDescription = ''
      Leveraging Apple's Endpoint Security Framework,
      this utility monitors file events (such as creation, modifications, and deletions)
      providing detailed information about such events.
    '';
    homepage = "https://objective-see.org/products/utilities.html#FileMonitor";
    downloadPage = "https://objective-see.org/products/utilities.html#FileMonitor";
    changelog = "https://objective-see.org/products/changelogs/FileMonitor.txt";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    identifiers = {
      cpeParts = {
        vendor = "objective-see";
        product = "filemonitor";
        version = finalAttrs.version;
        target_sw = "macos";
      };
      purlParts = {
        type = "generic";
        spec = "objective-see/filemonitor@${finalAttrs.version}?download_url=https://bitbucket.org/objective-see/deploy/downloads/FileMonitor_${finalAttrs.version}.zip";
      };
    };
    maintainers = with lib.maintainers; [ KristijanZic ];
  };
})
