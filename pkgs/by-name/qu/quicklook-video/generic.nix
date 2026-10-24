{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  nix-update-script,
}:

{
  version,
  hash,
  minimumMacOSVersion,
}:

stdenvNoCC.mkDerivation (
  finalAttrs:
  let
    majorVersion = lib.versions.major finalAttrs.version;
    releaseVersion = lib.replaceStrings [ "." ] [ "" ] finalAttrs.version;
    upstreamUrl = "https://github.com/Marginal/QuickLookVideo";
  in
  {
    pname = "quicklook-video";
    inherit version;

    strictDeps = true;
    __structuredAttrs = true;

    src = fetchurl {
      url = "${upstreamUrl}/releases/download/rel-${releaseVersion}/QLVideo_${releaseVersion}.dmg";
      inherit hash;
    };

    nativeBuildInputs = [ undmg ];

    sourceRoot = "QuickLook Video.app";

    # Preserve the upstream signatures of the app and its embedded extensions.
    dontFixup = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications/QuickLook Video.app"
      cp -R . "$out/Applications/QuickLook Video.app"

      runHook postInstall
    '';

    passthru.updateScript = nix-update-script {
      attrPath = "quicklook-video_${majorVersion}";
      extraArgs = [
        # Older release series may no longer appear in GitHub's Atom feed.
        "--use-github-releases"
        # Capture groups turn tags such as rel-312 into version 3.12.
        "--version-regex=^rel-(${majorVersion})([0-9]+)$"
        "--override-filename=pkgs/by-name/qu/quicklook-video/${majorVersion}.nix"
      ];
    };

    meta = {
      description = "Finder thumbnails, Quick Look previews, and media metadata (requires macOS ${minimumMacOSVersion}+)";
      longDescription = ''
        QuickLook Video adds Finder thumbnails, Quick Look previews, and
        metadata support for additional media formats.

        Requires macOS ${minimumMacOSVersion} or later.

        Launch the app once after installation to register its extensions.
      '';
      homepage = upstreamUrl;
      changelog = "${upstreamUrl}/releases/tag/rel-${releaseVersion}";
      license = lib.licenses.gpl2Plus;
      maintainers = with lib.maintainers; [ kinnrai ];
      platforms = lib.platforms.darwin;
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  }
)
