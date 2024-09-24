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
  version = "0.4.2";

  src =
    fetchurl
      {
        aarch64-darwin = {
          url = "https://github.com/spacedriveapp/spacedrive/releases/download/${version}/Spacedrive-darwin-aarch64.dmg";
          hash = "sha256-W0nFNmBgrypTj1Y6r6vstdL0UUaP9jTOH5RgAirwxsY=";
        };
        x86_64-darwin = {
          url = "https://github.com/spacedriveapp/spacedrive/releases/download/${version}/Spacedrive-darwin-x86_64.dmg";
          hash = "sha256-iX7aUs2k1fjOoDxkgXbePEYXYKFK3rGFlN9b0+gz378=";
        };
        x86_64-linux = {
          url = "https://github.com/spacedriveapp/spacedrive/releases/download/${version}/Spacedrive-linux-x86_64.deb";
          hash = "sha256-SbuL96xNEOPZ3Z5jd0gfJtNkUoEjO4W+P7K9mvyNmHA=";
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
if stdenv.hostPlatform.isDarwin then
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
