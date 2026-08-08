{
  lib,
  stdenvNoCC,
  fetchzip,
  makeWrapper,
  writeShellApplication,
  testers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "processmonitor";
  version = "1.5.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchzip {
    url = "https://bitbucket.org/objective-see/deploy/downloads/ProcessMonitor_${finalAttrs.version}.zip";
    hash = "sha256-FQvQ80YVH6kSkAKKLWVaNdLCB5CqIBqG0vkD97KVEcs=";

    stripRoot = false;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R ProcessMonitor.app $out/Applications/

    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/bin
    makeWrapper $out/Applications/ProcessMonitor.app/Contents/MacOS/ProcessMonitor $out/bin/processmonitor
  '';

  passthru = {
    updateScript = lib.getExe (writeShellApplication {
      name = "update-processmonitor";
      text = ''
        latest_version=$(curl -s https://objective-see.org/products/changelogs/ProcessMonitor.txt | grep -m1 -oE '[0-9]+\.[0-9]+\.[0-9]+')
        update-source-version processmonitor "$latest_version"
      '';
    });

    tests = {
      help = testers.runCommand {
        name = "processmonitor-help-test";
        buildInputs = [ finalAttrs.finalPackage ];
        script = ''
          # Capture both stdout and stderr, and use `|| true` to suppress the 255 exit code
          # which occurs because of the wrong help exit code imlementation in processmonitor
          # Fix when this is merged: https://github.com/objective-see/ProcessMonitor/pull/11
          output=$(processmonitor -h 2>&1 || true)

          echo "$output" | grep -F "ProcessMonitor (v${finalAttrs.version})"

          touch $out
        '';
      };
    };
  };

  meta = {
    mainProgram = "processmonitor";
    description = "Advanced utility that monitors process creations and terminations on macOS";
    longDescription = ''
      ProcessMonitor leverages Apple's Endpoint Security Framework to capture system-wide process events.
    '';
    homepage = "https://objective-see.org/products/utilities.html#ProcessMonitor";
    downloadPage = "https://objective-see.org/products/utilities.html#ProcessMonitor";
    changelog = "https://objective-see.org/products/changelogs/ProcessMonitor.txt";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    identifiers = {
      cpeParts = {
        vendor = "objective-see";
        product = "processmonitor";
        version = finalAttrs.version;
        target_sw = "macos";
      };
      purlParts = {
        type = "generic";
        spec = "objective-see/processmonitor@${finalAttrs.version}?download_url=https://bitbucket.org/objective-see/deploy/downloads/ProcessMonitor_${finalAttrs.version}.zip";
      };
    };
    maintainers = with lib.maintainers; [ KristijanZic ];
  };
})
