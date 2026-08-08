{
  lib,
  stdenvNoCC,
  fetchzip,
  makeWrapper,
  nix-update-script,
  testers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "knockknock";
  version = "4.0.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchzip {
    url = "https://github.com/objective-see/KnockKnock/releases/download/v${finalAttrs.version}/KnockKnock_${finalAttrs.version}.zip";
    hash = "sha256-KHXnjHY11UYHEztcEGIhVf+G34IKLN5mftjVUxnsLbM=";

    stripRoot = false;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R KnockKnock.app $out/Applications/

    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/bin
    makeWrapper $out/Applications/KnockKnock.app/Contents/MacOS/KnockKnock $out/bin/${finalAttrs.pname}
  '';

  passthru = {
    updateScript = nix-update-script { };

    tests = {
      version = testers.runCommand {
        name = "knockknock-version-test";
        buildInputs = [ finalAttrs.finalPackage ];
        script = ''
          # Capture both stdout and stderr, and use `|| true` to suppress the 255 exit code
          # which occurs because of the wrong version exit code imlementation in knockknock
          # Fix when this is merged: https://github.com/objective-see/KnockKnock/pull/53
          output=$(knockknock -version 2>&1 || true)

          echo "$output" | grep -F "KnockKnock Version: ${finalAttrs.version}"

          touch $out
        '';
      };

      help = testers.runCommand {
        name = "knockknock-help-test";
        buildInputs = [ finalAttrs.finalPackage ];
        script = ''
          # Capture both stdout and stderr, and use `|| true` to suppress the 255 exit code
          # which occurs because of the wrong help exit code imlementation in knockknock
          # Fix when this is merged: https://github.com/objective-see/KnockKnock/pull/53
          output=$(knockknock -h 2>&1 || true)

          echo "$output" | grep -F "KNOCKNOCK USAGE:"

          touch $out
        '';
      };
    };
  };

  meta = {
    mainProgram = "knockknock";
    description = "Advanced utility that shows what is persistently installed on the computer";
    longDescription = ''
      "Who's there?", See what's persistently installed on your Mac!
      Malware often installs itself persistently, to ensure it is automatically
      (re)executed each time a computer is restarted. KnockKnock uncovers persistently
      installed software in order to generically reveal such malware.
    '';
    homepage = "https://objective-see.org/products/knockknock.html";
    downloadPage = "https://github.com/objective-see/KnockKnock/releases/tag/v${finalAttrs.version}";
    changelog = "https://github.com/objective-see/KnockKnock/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    identifiers = {
      cpeParts = {
        vendor = "objective-see";
        product = "knockknock";
        version = finalAttrs.version;
        target_sw = "macos";
      };
      purlParts = {
        type = "github";
        namespace = "objective-see";
        name = "knockknock";
        version = finalAttrs.version;
      };
    };
    maintainers = with lib.maintainers; [ KristijanZic ];
  };
})
