{ theme ? null, stdenv, fetchurl, dpkg, makeWrapper , alsaLib, atk, cairo,
cups, curl, dbus, expat, fontconfig, freetype, glib , gnome2, gtk3, gdk-pixbuf,
libappindicator-gtk3, libnotify, libxcb, nspr, nss, pango , systemd, xorg,
at-spi2-atk, at-spi2-core, libuuid, nodePackages, libpulseaudio, xdg_utils
}:

let

  version = "4.2.0";

  inherit (stdenv.hostPlatform) system;

  throwSystem = throw "Unsupported system: ${system}";

  pname = "slack";

  sha256 = {
    x86_64-darwin = "0947a98m7yz4hldjvcqnv9s17dpvlsk9sflc1zc99hf500zck0w1";
    x86_64-linux = "01b2klhky04fijdqcpfafgdqx2c5nh2fpnzvzgvz10hv7h16cinv";
  }.${system} or throwSystem;


  meta = with stdenv.lib; {
    description = "Desktop client for Slack";
    homepage = https://slack.com;
    license = licenses.unfree;
    maintainers = [ maintainers.mmahut ];
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
  };

  linux = stdenv.mkDerivation rec {
    inherit pname version meta;
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
      glib
      gnome2.GConf
      gdk-pixbuf
      gtk3
      pango
      libnotify
      libxcb
      libappindicator-gtk3
      nspr
      nss
      stdenv.cc.cc
      systemd
      libuuid
      libpulseaudio
  
      xorg.libxkbfile
      xorg.libX11
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      xorg.libXScrnSaver
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
    '' + stdenv.lib.optionalString (theme != null) ''
      asar extract $out/lib/slack/resources/app.asar $out/lib/slack/resources/app.asar.unpacked
      cat <<EOF >> $out/lib/slack/resources/app.asar.unpacked/dist/ssb-interop.bundle.js
  
      var fs = require('fs');
      document.addEventListener('DOMContentLoaded', function() {
        fs.readFile('${theme}/theme.css', 'utf8', function(err, css) {
          let s = document.createElement('style');
          s.type = 'text/css';
          s.innerHTML = css;
          document.head.appendChild(s);
        });
      });
      EOF
      asar pack $out/lib/slack/resources/app.asar.unpacked $out/lib/slack/resources/app.asar
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit pname version meta;

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
