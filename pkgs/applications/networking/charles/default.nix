{
  lib,
  stdenv,
  makeWrapper,
  makeDesktopItem,
  fetchurl,
  undmg,
  jdk25,
  jdk11,
  jdk8,
  writeScript,
}:

let
  generic =
    {
      version,
      sources,
      jdk,
      updateScript ? null,
      mainProgram ? "charles",
      ...
    }:
    let
      srcData =
        sources.${stdenv.hostPlatform.system}
          or (throw "Unsupported system: ${stdenv.hostPlatform.system} for Charles ${version}. Supported systems are: ${lib.concatStringsSep ", " (builtins.attrNames sources)}");

      desktopItem = makeDesktopItem {
        categories = [
          "Network"
          "Development"
          "WebDevelopment"
          "Java"
        ];
        desktopName = "Charles";
        exec = "${mainProgram} %F";
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
        inherit (srcData) url hash;
        curlOptsList = [
          "--user-agent"
          "Mozilla/5.0"
        ]; # HTTP 104 otherwise
      };

      nativeBuildInputs = [ makeWrapper ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ undmg ];

      sourceRoot = if stdenv.hostPlatform.isDarwin then "." else null;

      installPhase =
        if stdenv.hostPlatform.isDarwin then
          ''
            runHook preInstall

            mkdir -p $out/Applications $out/bin
            cp -R Charles.app $out/Applications/

            makeWrapper "$out/Applications/Charles.app/Contents/MacOS/Charles" "$out/bin/${mainProgram}"

            runHook postInstall
          ''
        else
          ''
            runHook preInstall

            makeWrapper ${jdk}/bin/java $out/bin/${mainProgram} \
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
        sourceProvenance = with lib.sourceTypes; [
          binaryBytecode
          binaryNativeCode
        ];
        license = lib.licenses.unfree;
        inherit mainProgram;
        platforms = builtins.attrNames sources;
      };
      passthru.updateScript = updateScript;
    };

in
{
  charles5 = (
    generic rec {
      version = "5.2";
      jdk = jdk25;

      sources = {
        "x86_64-linux" = {
          url = "https://www.charlesproxy.com/assets/release/${version}/charles-proxy-${version}_x86_64.tar.gz";
          hash = "sha256-8B/+YXz7Nwnn2DhLc5K8S9E5vz1eCvv+V5GoGoK9x4k=";
        };
        "x86_64-darwin" = {
          url = "https://www.charlesproxy.com/assets/release/${version}/charles-proxy-${version}.dmg";
          hash = "sha256-2gZhqCoQPCLshvZnsVgPuMTM6qwB5cTIFPi7N5+maEo=";
        };
        "aarch64-darwin" = {
          url = "https://www.charlesproxy.com/assets/release/${version}/charles-proxy-${version}.dmg";
          hash = "sha256-2gZhqCoQPCLshvZnsVgPuMTM6qwB5cTIFPi7N5+maEo=";
        };
      };

      updateScript = writeScript "update-charles" ''
        #!/usr/bin/env nix-shell
        #!nix-shell -i bash -p curl gnugrep nix-update

        set -eu -o pipefail

        version=$(curl -A "Mozilla/5.0" -s https://www.charlesproxy.com/download/ | grep -oP 'Version \K[0-9.]+' | head -n1)

        for system in x86_64-linux x86_64-darwin aarch64-darwin; do
          nix-update charles5 --version "$version" --system "$system"
        done
      '';
    }
  );

  charles4 = (
    generic rec {
      version = "4.6.8";
      jdk = jdk11;

      sources = {
        "x86_64-linux" = {
          url = "https://www.charlesproxy.com/assets/release/${version}/charles-proxy-${version}_amd64.tar.gz";
          hash = "sha256-AaS+zmQTWsGoLEhyGHA/UojmctE7IV0N9fnygNhEPls=";
        };
        "x86_64-darwin" = {
          url = "https://www.charlesproxy.com/assets/release/${version}/charles-proxy-${version}.dmg";
          hash = "sha256-chXXj9csIBGRT1Za+hiEm1iFWIc1zgDFuFw09bVxH1Y=";
        };
        "aarch64-darwin" = {
          url = "https://www.charlesproxy.com/assets/release/${version}/charles-proxy-${version}.dmg";
          hash = "sha256-chXXj9csIBGRT1Za+hiEm1iFWIc1zgDFuFw09bVxH1Y=";
        };
      };
    }
  );

  charles3 = (
    generic rec {
      version = "3.12.3";
      jdk = jdk8.jre;

      sources = {
        "x86_64-linux" = {
          url = "https://www.charlesproxy.com/assets/release/${version}/charles-proxy-${version}.tar.gz";
          hash = "sha256-Wotxzf6kutYv1F6q71eJVojVJsATJ81war/w4K1A848=";
        };
        "x86_64-darwin" = {
          url = "https://www.charlesproxy.com/assets/release/${version}/charles-proxy-${version}.dmg";
          hash = "sha256-chByBPsWkY7VkLk8AJs7VCG9r0JTgfGlxVQkIyDqDKc=";
        };
        "aarch64-darwin" = {
          url = "https://www.charlesproxy.com/assets/release/${version}/charles-proxy-${version}.dmg";
          hash = "sha256-chByBPsWkY7VkLk8AJs7VCG9r0JTgfGlxVQkIyDqDKc=";
        };
      };
    }
  );
}
