{ stdenv
, fetchurl
, dpkg
, undmg
, makeWrapper
, nodePackages
, alsaLib
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
, gnome2
, gtk3
, libappindicator-gtk3
, libdrm
, libnotify
, libpulseaudio
, libuuid
, libxcb
, mesa
, nspr
, nss
, pango
, systemd
, xdg_utils
, xorg
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  pname = "slack";
  version = {
    x86_64-darwin = "4.8.0";
    x86_64-linux = "4.8.0";
  }.${system} or throwSystem;

  src = let
    base = "https://downloads.slack-edge.com";
  in {
    x86_64-darwin = fetchurl {
      url = "${base}/releases/macos/${version}/prod/x64/Slack-${version}-macOS.dmg";
      sha256 = "0k22w3c3brbc7ivmc5npqy8h7zxfgnbs7bqwii03psymm6sw53j2";
    };
    x86_64-linux = fetchurl {
      url = "${base}/linux_releases/slack-desktop-${version}-amd64.deb";
      sha256 = "0q8qpz5nwhps7y5gq1bl8hjw7vsk789srrv39hzc7jrl8f1bxzk0";
    };
  }.${system} or throwSystem;

  meta = with stdenv.lib; {
    description = "Desktop client for Slack";
    homepage = "https://slack.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ mmahut ];
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
  };

  linux = stdenv.mkDerivation rec {
    inherit pname version src meta;

    rpath = stdenv.lib.makeLibraryPath [
      alsaLib
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
      gnome2.GConf
      gtk3
      libappindicator-gtk3
      libdrm
      libnotify
      libpulseaudio
      libuuid
      libxcb
      mesa
      nspr
      nss
      pango
      stdenv.cc.cc
      systemd
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
    ] + ":${stdenv.cc.cc.lib}/lib64";

    buildInputs = [
      gtk3  # needed for GSETTINGS_SCHEMAS_PATH
    ];

    nativeBuildInputs = [ dpkg makeWrapper nodePackages.asar ];

    dontUnpack = true;
    dontBuild = true;
    dontPatchELF = true;

    installPhase = ''
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

      # Replace the broken bin/slack symlink with a startup wrapper
      rm $out/bin/slack
      makeWrapper $out/lib/slack/slack $out/bin/slack \
        --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
        --prefix PATH : ${xdg_utils}/bin

      # Fix the desktop link
      substituteInPlace $out/share/applications/slack.desktop \
        --replace /usr/bin/ $out/bin/ \
        --replace /usr/share/ $out/share/
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ undmg ];

    sourceRoot = "Slack.app";

    installPhase = ''
      mkdir -p $out/Applications/Slack.app
      cp -R . $out/Applications/Slack.app
      /usr/bin/defaults write com.tinyspeck.slackmacgap SlackNoAutoUpdates -bool YES
    '';
  };
in if stdenv.isDarwin
  then darwin
  else linux
