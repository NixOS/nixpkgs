{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mailgpg";
  version = "0.3.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://github.com/mahaupt/mailgpg/releases/download/v${finalAttrs.version}/MailGPG-${finalAttrs.version}.dmg";
    hash = "sha256-lp29m/g6ynwKbUf7ne46E5B2wfxPHSGd8zFkIn26up0=";
  };

  # The release DMG uses APFS, which undmg cannot extract.
  nativeBuildInputs = [ _7zz ];
  sourceRoot = "MailGPG.app";

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications"
    cp -R . "$out/Applications/MailGPG.app"
    runHook postInstall
  '';

  # Preserve the signatures of both the host app and its embedded Mail extension.
  dontFixup = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Apple Mail extension for OpenPGP email encryption and signing";
    longDescription = ''
      Requires macOS 14 or later, GnuPG, and a graphical pinentry.
      The host app must run as a launch agent exposing the Mach service
      com.mahaupt.mailgpg.gpgservice. Enable the extension in Apple Mail's
      Settings > Extensions after installing the app.

      Version 0.3.1 only discovers GnuPG at Homebrew and GPG Suite paths;
      Nix-installed GnuPG is not yet detected.
    '';
    homepage = "https://github.com/mahaupt/mailgpg";
    changelog = "https://github.com/mahaupt/mailgpg/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ laontme ];
  };
})
