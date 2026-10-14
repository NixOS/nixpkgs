# Meant to become nixpkgs' pkgs/by-name/se/servitacto/package.nix — written
# to that directory's current naming/callPackage convention so it can be
# copied in with minimal changes when Kevin submits the PR himself (see
# README.md in this directory). Uses appimageTools.wrapType2, nixpkgs'
# standard pattern for packaging a pre-built Electron AppImage (the same
# "don't rebuild from source, just wrap/extract the real binary" approach
# as packaging/aur/PKGBUILD and packaging/copr/servitacto.spec — this is
# a proprietary, closed-build app, there's no source to build from).
{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "servitacto";
  version = "1.0.3";

  src = fetchurl {
    url = "https://servitacto-public-releases-765148471844.s3.us-east-1.amazonaws.com/desktop/linux/ServiTacto-${version}.AppImage";
    # Real sha256 of the AppImage produced by the ServiTactoDesktopLinux-dev
    # CodeBuild run on 2026-10-14 (bumped from the stale 1.0.0 this pointed
    # at before — same version used for the Flathub/Snapcraft submissions
    # done the same day), converted to SRI form via
    # `nix hash convert --to sri --hash-algo sha256 <hex-sha256sum>`.
    hash = "sha256-ODoM4jBk8Nr7xZAIGo3qgkWf3MxaMjIQ8OZXwLZ9330=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/servitacto.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/servitacto.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'

    # Most pre-built Electron AppImages embed their own icon — extract it
    # from the unpacked contents rather than sourcing a second URL, same
    # approach as the AUR/Copr/OBS packages. Falls back to no icon
    # (generic one shows in app launchers) if extraction finds nothing;
    # not fatal to the build.
    if [ -f ${appimageContents}/servitacto.png ]; then
      install -Dm444 ${appimageContents}/servitacto.png \
        $out/share/icons/hicolor/512x512/apps/servitacto.png
    fi
  '';

  meta = {
    description = "Field service management desktop client — service orders, GPS timeclock, procurement, and billing";
    homepage = "https://servitacto.com";
    # Proprietary, all rights reserved — Hoos Works — see this repo's
    # LICENSE file. unfree (not a SPDX-listed license) is nixpkgs'
    # convention for exactly this case.
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.servitacto ];
    mainProgram = "servitacto";
  };
}
