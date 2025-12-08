{
  bash,
  buildFHSEnv,
  fetchurl,
  inotify-tools,
  lib,
  stdenvNoCC,
  sysctl,
  writeScript,
}:
let
  pname = "expressvpn";
  clientVersion = "5.0.1";
  clientBuild = "11498";
  version = lib.strings.concatStringsSep "." [
    clientVersion
    clientBuild
  ];

  # Determine architecture directory based on system
  archDir = if stdenvNoCC.hostPlatform.system == "x86_64-linux" then "x64" else "arm64";

  expressvpnBase = stdenvNoCC.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://www.expressvpn.works/clients/linux/expressvpn-linux-universal-${version}.run";
      hash = "sha256-OdSEuR1tOopq07a2fpPH/DBD2Rn27UgcejO4alTaJjA=";
      executable = true;
    };

    nativeBuildInputs = [ bash ];

    dontConfigure = true;
    dontBuild = true;

    unpackPhase = ''
      runHook preUnpack
      bash $src --noexec --target .
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/libexec/expressvpn
      cp -r ${archDir}/expressvpnfiles/* $out/libexec/expressvpn/

      # Install icon
      mkdir -p $out/share/icons/hicolor/256x256/apps
      install -m644 ${archDir}/installfiles/app-icon.png $out/share/icons/hicolor/256x256/apps/expressvpn.png

      # Install desktop file
      mkdir -p $out/share/applications
      install -m644 ${archDir}/installfiles/expressvpn.desktop $out/share/applications/

      runHook postInstall
    '';
  };

  # Common packages needed in FHS environment
  # Based on install.sh core_packages and gui_packages requirements
  fhsTargetPkgs =
    pkgs: with pkgs; [
      # Core dependencies (from install.sh)
      libnl # libnl-3-200, libnl-route-3-200
      iptables # iptables
      psmisc # psmisc (provides killall, pgrep)
      libatomic_ops # libatomic1
      brotli # libbrotli1 - REQUIRED for expressvpn-daemon
      iproute2 # iproute2
      cacert # ca-certificates

      # GUI dependencies (from install.sh)
      libxkbcommon # libxkbcommon-x11-0
      libGL # libopengl0
      xterm # xterm

      # Additional system libraries needed by the binaries
      dbus
      fontconfig
      freetype
      glib
      inotify-tools
      kdePackages.qtbase
      kdePackages.qtdeclarative
      kdePackages.qtwayland
      libcap_ng
      libgcc
      openssl

      # X11 libraries for GUI
      xorg.libICE
      xorg.libSM
      xorg.libX11
      xorg.libXau
      xorg.libxcb
      xorg.libXdmcp

      zlib
    ];

  expressvpndFHS = buildFHSEnv {
    inherit version;
    pname = "expressvpnd";

    # When connected, it directly creates/deletes resolv.conf to change the DNS entries.
    # Since it's running in an FHS environment, it has no effect on actual resolv.conf.
    # Hence, place a watcher that updates host resolv.conf when FHS resolv.conf changes.
    extraBwrapArgs = [
      "--bind"
      "/etc/resolv.conf"
      "/host/etc/resolv.conf"
    ];

    runScript = writeScript "expressvpn-daemon-wrapper" ''
      # expressvpn-daemon expects files at /opt/expressvpn
      mkdir -p /opt/expressvpn
      for subdir in bin lib plugins qml share; do
        rm -f -r /opt/expressvpn/$subdir
        ln -s ${expressvpnBase}/libexec/expressvpn/$subdir /opt/expressvpn/$subdir
      done
      mkdir -p /opt/expressvpn/etc
      mkdir -p /opt/expressvpn/var

      # Handle resolv.conf updates
      # The daemon modifies /etc/resolv.conf in the FHS environment
      # We watch for changes and sync them to the host
      rm -f /etc/resolv.conf
      cp /host/etc/resolv.conf /etc/resolv.conf
      while inotifywait -e modify,create,delete /etc/resolv.conf 2>/dev/null; do
        cp /etc/resolv.conf /host/etc/resolv.conf
      done &

      exec ${expressvpnBase}/libexec/expressvpn/bin/expressvpn-daemon
    '';

    # expressvpn-daemon binary has hard-coded the path /sbin/sysctl hence below workaround.
    extraBuildCommands = ''
      mkdir -p sbin
      chmod +w sbin
      ln -s ${sysctl}/bin/sysctl sbin/sysctl
    '';

    # The expressvpn-daemon binary also uses hard-coded paths to the other binaries and files
    # it ships with, hence the FHS environment.
    targetPkgs = fhsTargetPkgs;
  };

  # FHS environment for CLI tool
  expressvpnctlFHS = buildFHSEnv {
    inherit version;
    pname = "expressvpnctl";

    runScript = writeScript "expressvpn-ctl-wrapper" ''
      # expressvpnctl expects files at /opt/expressvpn
      mkdir -p /opt/expressvpn
      for subdir in bin lib plugins qml share; do
        rm -f -r /opt/expressvpn/$subdir
        ln -s ${expressvpnBase}/libexec/expressvpn/$subdir /opt/expressvpn/$subdir
      done

      exec ${expressvpnBase}/libexec/expressvpn/bin/expressvpnctl "$@"
    '';

    targetPkgs = fhsTargetPkgs;
  };

  # FHS environment for GUI client
  expressvpnClientFHS = buildFHSEnv {
    inherit version;
    pname = "expressvpn-client";

    runScript = writeScript "expressvpn-client-wrapper" ''
      # expressvpn-client expects files at /opt/expressvpn
      mkdir -p /opt/expressvpn
      for subdir in bin lib plugins qml share; do
        rm -f -r /opt/expressvpn/$subdir
        ln -s ${expressvpnBase}/libexec/expressvpn/$subdir /opt/expressvpn/$subdir
      done

      exec ${expressvpnBase}/libexec/expressvpn/bin/expressvpn-client "$@"
    '';

    targetPkgs = fhsTargetPkgs;
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    ln -s ${expressvpnClientFHS}/bin/expressvpn-client $out/bin/expressvpn
    ln -s ${expressvpnctlFHS}/bin/expressvpnctl $out/bin/expressvpnctl
    ln -s ${expressvpndFHS}/bin/expressvpnd $out/bin/expressvpn-daemon

    # Link icon
    mkdir -p $out/share
    ln -s ${expressvpnBase}/share/icons $out/share/

    # Copy and fix desktop file to use correct paths
    mkdir -p $out/share/applications
    substitute ${expressvpnBase}/share/applications/expressvpn.desktop \
      $out/share/applications/expressvpn.desktop \
      --replace-warn 'Path=/opt/expressvpn/bin/' "" \
      --replace-fail 'Exec=env XDG_SESSION_TYPE=X11 /opt/expressvpn/bin/expressvpn-client' \
                     "Exec=env XDG_SESSION_TYPE=X11 ${expressvpnClientFHS}/bin/expressvpn-client"

    runHook postInstall
  '';

  meta = with lib; {
    description = "CLI client for ExpressVPN";
    homepage = "https://www.expressvpn.com";
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with maintainers; [ yureien ];
  };
}
