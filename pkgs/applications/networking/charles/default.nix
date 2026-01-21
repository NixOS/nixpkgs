{
  lib,
  stdenv,
  makeWrapper,
  makeDesktopItem,
  fetchurl,
  openjdk17-bootstrap,
  jdk11,
  jdk8,
  writeScript,
}:

let
  generic =
    {
      version,
      hash,
      platform ? "",
      jdk,
      updateScript ? null,
      ...
    }@attrs:
    let
      desktopItem = makeDesktopItem {
        categories = [
          "Network"
          "Development"
          "WebDevelopment"
          "Java"
        ];
        desktopName = "Charles";
        exec = "charles %F";
        genericName = "Web Debugging Proxy";
        icon = "charles-proxy" + lib.optionalString (lib.versionAtLeast version "5.0") "5";
        mimeTypes = [
          "application/x-charles-savedsession"
          "application/x-charles-savedsession+xml"
          "application/x-charles-savedsession+json"
          "application/har+json"
          "application/vnd.tcpdump.pcap"
          "application/x-charles-trace"
        ];
        name = "Charles";
        startupNotify = true;
      };

    in
    stdenv.mkDerivation {
      pname = "charles";
      inherit version;

      src = fetchurl {
        url = "https://www.charlesproxy.com/assets/release/${version}/charles-proxy-${version}${platform}.tar.gz";
        curlOptsList = [
          "--user-agent"
          "Mozilla/5.0"
        ]; # HTTP 104 otherwise
        inherit hash;
      };

      nativeBuildInputs = [ makeWrapper ];

      installPhase = ''
        runHook preInstall

        makeWrapper ${jdk}/bin/java $out/bin/charles \
          --add-flags "-Xmx1024M -Dcharles.config='~/.charles.config' ${lib.optionalString (lib.versionOlder version "5.0") "-jar $out/share/java/charles.jar"} ${lib.optionalString (lib.versionAtLeast version "5.0") "-XX:+UseZGC -Djava.library.path='$out/share/java' --add-opens java.base/sun.security.ssl=com.charlesproxy --add-opens java.desktop/java.awt.event=com.charlesproxy --add-opens java.base/java.io=com.charlesproxy --add-modules com.jthemedetector,com.formdev.flatlaf --module-path '$out/share/java' -m com.charlesproxy"}"

        for fn in lib/*.jar; do
          install -D -m644 $fn $out/share/java/$(basename $fn)
        done

        mkdir -p $out/share/applications
        ln -s ${desktopItem}/share/applications/* $out/share/applications/

        ${
          if lib.versionOlder version "4.0" then
            ''
              for size in 16 32 48 64 128 256 512; do
                install -Dm644 icon/charles_icon$size.png $out/share/icons/hicolor/''${size}x''${size}/apps/charles-proxy.png
              done
              install -Dm644 icon/charles_icon.svg $out/share/icons/hicolor/scalable/apps/charles-proxy.svg
            ''
          else
            ''
              mkdir -p $out/share/icons
              cp -r icon $out/share/icons/hicolor
              if [ -d "etc/mime" ]; then
                mkdir -p $out/share/mime/packages
                cp etc/mime/*.xml $out/share/mime/packages/
              fi
            ''
        }

        runHook postInstall
      '';

      meta = {
        description = "Web Debugging Proxy";
        homepage = "https://www.charlesproxy.com/";
        maintainers = with lib.maintainers; [
          kalbasit
          kashw2
          Misaka13514
        ];
        sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
        license = lib.licenses.unfree;
        platforms = lib.platforms.unix;
      };
      passthru.updateScript = updateScript;
    };

in
{
  charles5 = (
    generic {
      version = "5.0.3";
      hash = "sha256-SiZ15ekuAW7AyXBHN5Zel4ZFL/4oNy1td64NQ0GNUhE=";
      platform = "_x86_64";
      jdk = openjdk17-bootstrap;

      updateScript = writeScript "update-charles" ''
        #!/usr/bin/env nix-shell
        #!nix-shell -i bash -p curl gnugrep common-updater-scripts

        set -eu -o pipefail

        version=$(curl -A "Mozilla/5.0" -s https://www.charlesproxy.com/download/ | grep -oP 'Version \K[0-9.]+' | head -n1)

        update-source-version charles5 "$version"
      '';
    }
  );
  charles4 = (
    generic {
      version = "4.6.8";
      hash = "sha256-AaS+zmQTWsGoLEhyGHA/UojmctE7IV0N9fnygNhEPls=";
      platform = "_amd64";
      jdk = jdk11;
    }
  );
  charles3 = (
    generic {
      version = "3.12.3";
      hash = "sha256-Wotxzf6kutYv1F6q71eJVojVJsATJ81war/w4K1A848=";
      jdk = jdk8.jre;
      mainProgram = "charles";
    }
  );
}
