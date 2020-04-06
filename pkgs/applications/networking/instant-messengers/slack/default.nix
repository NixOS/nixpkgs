{ stdenv
, fetchurl
, dpkg
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
, libnotify
, libpulseaudio
, libuuid
, libxcb
, nspr
, nss
, pango
, systemd
, xdg_utils
, xorg
}:

let

  pname = "slack";

  inherit (stdenv.hostPlatform) system;

  throwSystem = throw "Unsupported system: ${system}";

  sha256 = {
    x86_64-darwin = "05xsbiviikrwfayjr6rvvfkm70681x2an6mgcg1cxw1fsi4sr6fd";
    x86_64-linux = "0h2rfgx92yq9a6dqsv9a0r8a6m5xfrywkljjk5w9snw49b0r1p12";
  }.${system} or throwSystem;

  meta = with stdenv.lib; {
    description = "Desktop client for Slack";
    homepage = https://slack.com;
    license = licenses.unfree;
    maintainers = with maintainers; [ mmahut ];
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
  };

  linux = stdenv.mkDerivation rec {
    inherit pname meta;
    version = "4.4.0";
    src = fetchurl {
      url = "https://downloads.slack-edge.com/linux_releases/slack-desktop-${version}-amd64.deb";
      inherit sha256;
    };

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
      libnotify
      libpulseaudio
      libuuid
      libxcb
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

  darwin = stdenv.mkDerivation rec {
    inherit pname meta;
    version = "4.4.1";

    phases = [ "installPhase" ];

    src = fetchurl {
      url = "https://downloads.slack-edge.com/mac_releases/Slack-${version}-macOS.dmg";
      inherit sha256;
    };

    installPhase = ''
      /usr/bin/hdiutil mount -nobrowse -mountpoint slack-mnt $src
      mkdir -p $out/Applications
      cp -r ./slack-mnt/Slack.app $out/Applications
      /usr/bin/hdiutil unmount slack-mnt
      defaults write com.tinyspeck.slackmacgap SlackNoAutoUpdates -bool YES
    '';
  };
in if stdenv.isDarwin
  then darwin
  else linux
