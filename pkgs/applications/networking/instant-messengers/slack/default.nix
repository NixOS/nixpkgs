{ lib
, stdenv
, fetchurl
, dpkg
, undmg
, makeWrapper
, nodePackages
, alsa-lib
, at-spi2-atk
, at-spi2-core
, atk
, cairo
, cups
, curl
, dbus
, expat
, fontconfig
, freetype
, gdk-pixbuf
, glib
, gtk3
, libGL
, libappindicator-gtk3
, libdrm
, libnotify
, libpulseaudio
, libuuid
, libxcb
, libxkbcommon
, libxshmfence
, mesa
, nspr
, nss
, pango
, pipewire
, systemd
, wayland
, xdg-utils
, xorg
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "slack does not support system: ${system}";

  pname = "slack";

  x86_64-darwin-version = "4.33.73";
  x86_64-darwin-sha256 = "0y8plkl3pm8250xpavc91kn5b9gcdwr7bqzd3i79n48395lx11ka";

  x86_64-linux-version = "4.33.73";
  x86_64-linux-sha256 = "007i8sjnm1ikjxvgw6nisj4nmv99bwk0r4sfpvc2j4w4wk68sx3m";

  aarch64-darwin-version = "4.33.73";
  aarch64-darwin-sha256 = "15s3ss15yawb04dyzn82xmk1gs70sg2i3agsj2aw0xdx73yjl34p";

  version = {
    x86_64-darwin = x86_64-darwin-version;
    x86_64-linux = x86_64-linux-version;
    aarch64-darwin =  aarch64-darwin-version;
  }.${system} or throwSystem;


  src = let
    base = "https://downloads.slack-edge.com";
  in {
    x86_64-darwin = fetchurl {
      url = "${base}/releases/macos/${version}/prod/x64/Slack-${version}-macOS.dmg";
      sha256 = x86_64-darwin-sha256;
    };
    x86_64-linux = fetchurl {
      url = "${base}/releases/linux/${version}/prod/x64/slack-desktop-${version}-amd64.deb";
      sha256 = x86_64-linux-sha256;
    };
    aarch64-darwin = fetchurl {
      url = "${base}/releases/macos/${version}/prod/arm64/Slack-${version}-macOS.dmg";
      sha256 = aarch64-darwin-sha256;
    };
  }.${system} or throwSystem;

  meta = with lib; {
    description = "Desktop client for Slack";
    homepage = "https://slack.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ mmahut maxeaubrey ];
    platforms = [ "x86_64-darwin" "x86_64-linux" "aarch64-darwin" ];
    mainProgram = "slack";
  };

  linux = stdenv.mkDerivation rec {
    inherit pname version src meta;

    passthru.updateScript = ./update.sh;

    rpath = lib.makeLibraryPath [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      curl
      dbus
      expat
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      libGL
      libappindicator-gtk3
      libdrm
      libnotify
      libpulseaudio
      libuuid
      libxcb
      libxkbcommon
      mesa
      nspr
      nss
      pango
      pipewire
      stdenv.cc.cc
      systemd
      wayland
      xorg.libX11
      xorg.libXScrnSaver
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      xorg.libxkbfile
      xorg.libxshmfence
    ] + ":${stdenv.cc.cc.lib}/lib64";

    buildInputs = [
      gtk3 # needed for GSETTINGS_SCHEMAS_PATH
    ];

    nativeBuildInputs = [ dpkg makeWrapper nodePackages.asar ];

    dontUnpack = true;
    dontBuild = true;
    dontPatchELF = true;

    installPhase = ''
      runHook preInstall

      # The deb file contains a setuid binary, so 'dpkg -x' doesn't work here
      dpkg --fsys-tarfile $src | tar --extract
      rm -rf usr/share/lintian

      mkdir -p $out
      mv usr/* $out

      # Otherwise it looks "suspicious"
      chmod -R g-w $out

      for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* \) ); do
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
        patchelf --set-rpath ${rpath}:$out/lib/slack $file || true
      done

      # Replace the broken bin/slack symlink with a startup wrapper.
      # Make xdg-open overrideable at runtime.
      rm $out/bin/slack
      makeWrapper $out/lib/slack/slack $out/bin/slack \
        --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
        --suffix PATH : ${lib.makeBinPath [xdg-utils]} \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer}}"

      # Fix the desktop link
      substituteInPlace $out/share/applications/slack.desktop \
        --replace /usr/bin/ $out/bin/ \
        --replace /usr/share/pixmaps/slack.png slack \
        --replace bin/slack "bin/slack -s"

      runHook postInstall
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src meta;

    passthru.updateScript = ./update.sh;

    nativeBuildInputs = [ undmg ];

    sourceRoot = "Slack.app";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications/Slack.app
      cp -R . $out/Applications/Slack.app
      runHook postInstall
    '';
  };
in
if stdenv.isDarwin
then darwin
else linux
