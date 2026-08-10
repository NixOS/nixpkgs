{
  lib,
  stdenvNoCC,
  fetchzip,
  makeWrapper,
  nix-update-script,
  testers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "netiquette";
  version = "2.3.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchzip {
    url = "https://github.com/objective-see/Netiquette/releases/download/v${finalAttrs.version}/Netiquette_${finalAttrs.version}.zip";
    hash = "sha256-AYYihId50MgWhJ6rrnqoVJOBPRfUoDz5ymUHCGUXJn8=";

    stripRoot = false;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R Netiquette.app "$out/Applications/Netiquette.app"

    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/bin
    makeWrapper $out/Applications/Netiquette.app/Contents/MacOS/Netiquette $out/bin/netiquette
  '';

  dontFixup = true; # Preserve upstream's notarized app bundle and system extension signature.

  passthru = {
    updateScript = nix-update-script { };

    tests = {
      help = testers.runCommand {
        name = "netiquette-help-test";
        buildInputs = [ finalAttrs.finalPackage ];
        script = ''
          # Capture both stdout and stderr, and use `|| true` to suppress the 255 exit code
          # which occurs because of the wrong help exit code imlementation in netiquette
          # Fix when this is merged: https://github.com/objective-see/Netiquette/pull/25
          output=$(netiquette -h 2>&1 || true)

          echo "$output" | grep -F "NETIQUETTE USAGE:"

          touch $out
        '';
      };
    };
  };

  meta = {
    mainProgram = "netiquette";
    description = "Network monitor";
    longDescription = ''
      In today’s interconnected world, it’s uncommon to find an application—or
      even malware—that doesn’t make use of the network.
      Netiquette is a network monitor that lets you explore all sockets
      and connections through an interactive UI or the command line.
    '';
    homepage = "https://objective-see.org/products/netiquette.html";
    downloadPage = "https://github.com/objective-see/Netiquette/releases";
    changelog = "https://github.com/objective-see/Netiquette/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    identifiers = {
      cpeParts = {
        vendor = "objective-see";
        product = "netiquette";
        version = finalAttrs.version;
        target_sw = "macos";
      };
      purlParts = {
        type = "github";
        namespace = "objective-see";
        name = "netiquette";
        version = finalAttrs.version;
      };
    };
    maintainers = with lib.maintainers; [
      KristijanZic
    ];
  };
})
