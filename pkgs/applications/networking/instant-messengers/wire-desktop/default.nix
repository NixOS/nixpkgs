{ atomEnv
, autoPatchelfHook
, dpkg
, fetchurl
, makeDesktopItem
, makeWrapper
, stdenv
, lib
, udev
, wrapGAppsHook
, cpio
, xar
, libdbusmenu
}:

let

  inherit (stdenv.hostPlatform) system;

  throwSystem = throw "Unsupported system: ${system}";

  pname = "wire-desktop";

  version = {
    x86_64-darwin = "3.26.4145";
    x86_64-linux = "3.26.2941";
  }.${system} or throwSystem;

  sha256 = {
    x86_64-darwin = "1ck74a9z2mrwmljrqm347bqhjiaf1v0bf1jfnp58cqngh5ygqnf2";
    x86_64-linux = "01gy84gr0gw5ap7hpy72azaf6hlzac7vxkn5cgad5sfbyzxgjgc9";
  }.${system} or throwSystem;

  meta = with lib; {
    description = "A modern, secure messenger for everyone";
    longDescription = ''
      Wire Personal is a secure, privacy-friendly messenger. It combines useful
      and fun features, audited security, and a beautiful, distinct user
      interface.  It does not require a phone number to register and chat.

        * End-to-end encrypted chats, calls, and files
        * Crystal clear voice and video calling
        * File and screen sharing
        * Timed messages and chats
        * Synced across your phone, desktop and tablet
    '';
    homepage = "https://wire.com/";
    downloadPage = "https://wire.com/download/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      arianvp
      kiwi
      toonn
    ];
    platforms = [
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };

  linux = stdenv.mkDerivation rec {
    inherit pname version meta;

    src = fetchurl {
      url = "https://wire-app.wire.com/linux/debian/pool/main/"
      + "Wire-${version}_amd64.deb";
      inherit sha256;
    };

    desktopItem = makeDesktopItem {
      categories = [ "Network" "InstantMessaging" "Chat" "VideoConference" ];
      comment = "Secure messenger for everyone";
      desktopName = "Wire";
      exec = "wire-desktop %U";
      genericName = "Secure messenger";
      icon = "wire-desktop";
      name = "wire-desktop";
      startupWMClass = "Wire";
    };

    dontBuild = true;
    dontConfigure = true;
    dontPatchELF = true;
    dontWrapGApps = true;

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
      makeWrapper
      wrapGAppsHook
    ];

    buildInputs = atomEnv.packages;

    unpackPhase = ''
      runHook preUnpack

      dpkg-deb -x $src .

      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/bin"
      cp -R "opt" "$out"
      cp -R "usr/share" "$out/share"
      chmod -R g-w "$out"

      # Desktop file
      mkdir -p "$out/share/applications"
      cp "${desktopItem}/share/applications/"* "$out/share/applications"

      runHook postInstall
    '';

    runtimeDependencies = [
      (lib.getLib udev)
      libdbusmenu
    ];

    postFixup = ''
      makeWrapper $out/opt/Wire/wire-desktop $out/bin/wire-desktop \
        "''${gappsWrapperArgs[@]}"
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit pname version meta;

    src = fetchurl {
      url = "https://github.com/wireapp/wire-desktop/releases/download/"
          + "macos%2F${version}/Wire.pkg";
      inherit sha256;
    };

    buildInputs = [
      cpio
      xar
    ];

    unpackPhase = ''
      runHook preUnpack

      xar -xf $src
      cd com.wearezeta.zclient.mac.pkg

      runHook postUnpack
    '';

    buildPhase = ''
      runHook preBuild

      cat Payload | gunzip -dc | cpio -i

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications
      cp -r Wire.app $out/Applications

      runHook postInstall
    '';
  };

in
if stdenv.isDarwin
then darwin
else linux
