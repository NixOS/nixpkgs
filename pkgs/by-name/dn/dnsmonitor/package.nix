{
  lib,
  stdenvNoCC,
  fetchzip,
  makeWrapper,
  nix-update-script,
  testers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dnsmonitor";
  version = "1.3.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchzip {
    url = "https://github.com/objective-see/DNSMonitor/releases/download/v${finalAttrs.version}/DNSMonitor_${finalAttrs.version}.zip";
    hash = "sha256-J77KwIbZXiQfrWCiReU9kKm09z4ivnqjDWL5Y9/KDV8=";

    stripRoot = false;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R DNSMonitor.app $out/Applications/

    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/bin
    makeWrapper $out/Applications/DNSMonitor.app/Contents/MacOS/DNSMonitor $out/bin/${finalAttrs.pname}
  '';

  passthru = {
    updateScript = nix-update-script { };

    tests = {
      help = testers.runCommand {
        name = "dnsmonitor-help-test";
        buildInputs = [ finalAttrs.finalPackage ];
        script = ''
          # Capture both stdout and stderr, and use `|| true` to suppress the 255 exit code
          # which occurs because of the wrong help exit code imlementation in dnsmonitor
          # Fix when this is merged: https://github.com/objective-see/DNSMonitor/pull/12
          output=$(dnsmonitor -h 2>&1 || true)

          echo "$output" | grep -F "DNSMonitor (v${finalAttrs.version})"

          touch $out
        '';
      };
    };
  };

  meta = {
    mainProgram = "dnsmonitor";
    description = "Advanced utility that monitors DNS requests and responses on macOS";
    longDescription = ''
      Leveraging Apple Network Extension Framework, this utility monitors DNS requests and responses.
    '';
    homepage = "https://objective-see.org/products/utilities.html#DNSMonitor";
    downloadPage = "https://objective-see.org/products/utilities.html#DNSMonitor";
    changelog = "https://github.com/objective-see/DNSMonitor/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    identifiers = {
      cpeParts = {
        vendor = "objective-see";
        product = "dnsmonitor";
        version = finalAttrs.version;
        target_sw = "macos";
      };
      purlParts = {
        type = "github";
        namespace = "objective-see";
        name = "dnsmonitor";
        version = finalAttrs.version;
      };
    };
    maintainers = with lib.maintainers; [ KristijanZic ];
  };
})
