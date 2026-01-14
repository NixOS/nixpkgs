{
  lib,
  stdenv,
  buildFHSEnv,
  fetchurl,
  writeScript,
  gtk3,
  atk,
  glib,
  pango,
  gdk-pixbuf,
  cairo,
  libxml2,
  systemd,
  boost,
  zlib,

  zsh,
}:

let
  cisco-secure-client = stdenv.mkDerivation rec {
    pname = "cisco-secure-client";
    version = "5.1.6.103";

    src = fetchurl {
      url = "https://www.aim.aoyama.ac.jp/files/vpn/cisco-secure-client-linux64-${version}-predeploy-k9.tar.gz";
      hash = "sha256-PgtDP3BMaXcJ2pKwMkCOJqY9oBLzGPdabNmtRfoq40Y=";
    };

    preferLocalBuild = true;

    installPhase = ''
      cd vpn
      # install binaries
      for binary in "vpnagentd" "vpn" "vpndownloader" "vpndownloader-cli" "manifesttool_vpn" "acinstallhelper" "vpnui" "acwebhelper" "load_tun.sh"; do
        install -Dm755 $binary "$out/bin/$binary"
      done

      # install libs
      for lib in "libvpnagentutilities.so" "libvpncommon.so" "libvpncommoncrypt.so" \
        "libvpnapi.so" "libacruntime.so" "libacciscossl.so" "libacciscocrypto.so" \
        "cfom.so" "libboost_date_time.so" "libboost_filesystem.so" "libboost_regex.so" "libboost_system.so" \
        "libboost_thread.so" "libboost_chrono.so" \
        "libaccurl.so.4.8.0"; do
          install -Dm755 $lib "$out/lib/$lib"
      done

      # the installer copies all the other symlinks, but creates this one
      # for some reason so let's just create it ourselves
      ln -s $out/lib/libaccurl.so.4.8.0 "$out/lib/libaccurl.so.4"

      # install plugins
      # we intentionally don't install the telemetry plugin here
      # because it tries to write to /opt and we don't want that
      for plugin in "libacwebhelper.so" "libvpnipsec.so"; do
          install -Dm755 $plugin "$out/bin/plugins/$plugin"
      done

      cp -R resources "$out/resources"
    '';

    # stripping self extracting javascript binaries likely breaks them
    dontStrip = true;

    passthru = {
      fhs = buildFHSEnv {
        name = "cisco-secure-client-wrapper";

        targetPkgs = pkgs: [
          atk
          boost
          cairo
          cisco-secure-client
          gdk-pixbuf
          glib
          gtk3
          libxml2
          pango
          systemd
          zlib

          zsh
        ];

        extraBuildCommands = ''
        '';

        runScript = writeScript "cisco-secure-client-run-script" ''
          zsh
        '';
      };
    };

    meta = {
      description = "Cisco AnyConnect Secure Mobility Client";
      homepage = "https://www.cisco.com/site/us/en/products/security/secure-client";
      license = lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      maintainers = with lib.maintainers; [ onny ];
      mainProgram = "cisco-secure-client";
    };
  };
in
cisco-secure-client
