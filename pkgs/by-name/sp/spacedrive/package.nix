{
  lib,
  stdenv,
  fetchurl,
  undmg,
  nix-update-script,
  #linux required
  autoPatchelfHook,
  dpkg,
  gdk-pixbuf,
  glib,
  gst_all_1,
  libsoup,
  webkitgtk_4_1,
  xdotool,
}:

let
  pname = "spacedrive";
  version = "0.3.1";

  src =
    fetchurl
      {
        aarch64-darwin = {
          url = "https://github.com/spacedriveapp/spacedrive/releases/download/${version}/Spacedrive-darwin-aarch64.dmg";
          hash = "sha256-9E7h03zJtH8b6khDcbBsB46iVWwl48s+GJuBMOmEre4=";
        };
        x86_64-darwin = {
          url = "https://github.com/spacedriveapp/spacedrive/releases/download/${version}/Spacedrive-darwin-x86_64.dmg";
          hash = "sha256-h+B7tc6jXJUFNEMhG6ZNch+grtgUeAzfa37BDoZ6M8Q=";
        };
        x86_64-linux = {
          url = "https://github.com/spacedriveapp/spacedrive/releases/download/${version}/Spacedrive-linux-x86_64.deb";
          hash = "sha256-E1mOODG4YzBc0TPZJmKgrt/c5hp5LwzLaYPl+J5dnkg=";
        };
      }
      .${stdenv.system} or (throw "${pname}-${version}: ${stdenv.system} is unsupported.");

  meta = {
    description = "Open source file manager, powered by a virtual distributed filesystem";
    homepage = "https://www.spacedrive.com";
    changelog = "https://github.com/spacedriveapp/spacedrive/releases/tag/${version}";
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    license = lib.licenses.agpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      DataHearth
      heisfer
      mikaelfangel
      stepbrobd
    ];
    mainProgram = "spacedrive";
  };

  passthru.updateScript = nix-update-script { };
in
if stdenv.isDarwin then
  stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      passthru
      ;

    sourceRoot = "Spacedrive.app";

    nativeBuildInputs = [ undmg ];

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications/Spacedrive.app"
      cp -r . "$out/Applications/Spacedrive.app"
      mkdir -p "$out/bin"
      ln -s "$out/Applications/Spacedrive.app/Contents/MacOS/Spacedrive" "$out/bin/spacedrive"

      runHook postInstall
    '';
  }

else
  stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      passthru
      ;

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
    ];

    # Depends: libc6, libxdo3, libwebkit2gtk-4.1-0, libgtk-3-0
    # Recommends: gstreamer1.0-plugins-ugly
    # Suggests: gstreamer1.0-plugins-bad
    buildInputs = [
      xdotool
      glib
      libsoup
      webkitgtk_4_1
      gdk-pixbuf
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-base
      gst_all_1.gstreamer
    ];

    unpackPhase = ''
      runHook preUnpack

      dpkg-deb -x $src .

      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp -r usr/share $out/
      cp -r usr/lib $out/
      cp -r usr/bin $out/

      runHook postInstall
    '';
  }
