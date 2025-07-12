{
  bash,
  buildFHSEnv,
  fetchurl,
  inotify-tools,
  iptables,
  kdePackages,
  lib,
  libcap_ng,
  libgcc,
  libGL,
  libnl,
  libxkbcommon,
  openssl,
  psmisc,
  qt6,
  stdenvNoCC,
  writeScript,
  xorg,
}:
let
  pname = "expressvpn";
  clientVersion = "4.0.1";
  clientBuild = "9292";
  version = lib.strings.concatStringsSep "." [
    clientVersion
    clientBuild
  ];

  # Determine architecture directory based on system
  archDir = if stdenvNoCC.hostPlatform.system == "x86_64-linux" then "x64" else "arm64";

  # Base derivation to extract and place the unpatched ExpressVPN files
  expressvpnBase = stdenvNoCC.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://www.expressvpn.works/clients/linux/expressvpn-linux-universal-${version}.run";
      sha256 = "sha256-1GE2Y1msl+oSU5vTP1MJ5N2QNY8nWq1Rxithc/Tb1zs=";
      executable = true;
    };

    nativeBuildInputs = [ bash ];

    dontConfigure = true;
    dontBuild = true;

    unpackPhase = ''
      bash $src --noexec --target .
    '';

    installPhase = ''
      mkdir -p $out/libexec/expressvpn
      cp -r ${archDir}/expressvpnfiles/* $out/libexec/expressvpn/
      install -Dt "$out/share/icons/hicolor/256x256/apps" ${archDir}/installfiles/app-icon.png
      install -Dt "$out/share/applications" ${archDir}/installfiles/expressvpn.desktop
    '';
  };

  # Common dependencies for the FHS environment
  fhsTargetPkgs =
    pkgs: with pkgs; [
      dbus
      expressvpnBase
      fontconfig
      freetype
      glib
      inotify-tools
      iproute2
      iptables
      kdePackages.full
      kdePackages.wayland
      libcap_ng
      libgcc
      libGL
      libnl
      libxkbcommon
      openssl
      psmisc
      qt6.qtbase
      qt6.qtdeclarative
      sysctl
      xorg.libICE
      xorg.libSM
      xorg.libX11
      xorg.libXau
      xorg.libxcb
      xorg.libXdmcp
      zlib
    ];

  # FHS environment for the daemon with resolv.conf trick
  expressvpnDaemon = buildFHSEnv {
    name = "expressvpn-daemon";
    targetPkgs = fhsTargetPkgs;
    extraBwrapArgs = [
      "--bind"
      "/etc/resolv.conf" # host environment
      "/host/etc/resolv.conf" # FHS environment
    ];
    runScript = writeScript "expressvpn-daemon-wrapper" ''
      # expressvpn-daemon expects a lot of things to be put at /opt/expressvpn.
      # So we symlink them from /nix/store to make it happy.
      # The symlink works because /nix on host is binded read-only to /nix in FHS
      mkdir -p /opt/expressvpn
      for subdir in bin lib plugins qml share; do
        rm -f -r /opt/expressvpn/''$subdir
        ln -s ${expressvpnBase}/libexec/expressvpn/''$subdir /opt/expressvpn/''$subdir
      done

      # When connected, it directly creates/deletes resolv.conf to change the DNS entries.
      # Since it's running in an FHS environment, it has no effect on actual resolv.conf.
      # Hence, place a watcher that updates host resolv.conf when FHS resolv.conf changes.

      # Note that /etc/resolv.conf here belongs to FHS environment.
      rm -f /etc/resolv.conf # This line is required, or else error on the next line.
      cp /host/etc/resolv.conf /etc/resolv.conf
      while inotifywait -e modify,create,delete /etc/resolv.conf 2>/dev/null; do
        cp /etc/resolv.conf /host/etc/resolv.conf
      done &

      exec ${expressvpnBase}/libexec/expressvpn/bin/expressvpn-daemon
    '';
  };

  # FHS environment for the client GUI
  expressvpnClient = buildFHSEnv {
    name = "expressvpn-client";
    targetPkgs = fhsTargetPkgs;
    runScript = "${expressvpnBase}/libexec/expressvpn/bin/expressvpn-client";
  };

  # FHS environment for the CLI tool
  expressvpnCtl = buildFHSEnv {
    name = "expressvpnctl";
    targetPkgs = fhsTargetPkgs;
    runScript = "${expressvpnBase}/libexec/expressvpn/bin/expressvpnctl";
  };
in
# Final package combining everything
stdenvNoCC.mkDerivation {
  name = "expressvpn-package";

  buildInputs = [
    expressvpnBase
    expressvpnDaemon
    expressvpnClient
    expressvpnCtl
  ];

  dontUnpack = true;

  installPhase = ''
    # Create bin directory with symlinks to FHS wrappers
    mkdir -p $out/bin
    ln -s ${expressvpnDaemon}/bin/expressvpn-daemon $out/bin/expressvpn-daemon
    ln -s ${expressvpnClient}/bin/expressvpn-client $out/bin/expressvpn
    ln -s ${expressvpnCtl}/bin/expressvpnctl $out/bin/expressvpnctl

    # Symlink icons from the expressvpn derivation
    mkdir -p $out/share
    ln -s ${expressvpnBase}/share/icons $out/share/icons

    # Copy and modify the original desktop file
    mkdir -p $out/share/applications
    cp ${expressvpnBase}/share/applications/expressvpn.desktop $out/share/applications/
    substituteInPlace $out/share/applications/expressvpn.desktop \
      --replace-warn 'Path=/opt/expressvpn/bin/' "" \
      --replace-fail 'Exec=env XDG_SESSION_TYPE=X11 /opt/expressvpn/bin/expressvpn-client' "Exec=env XDG_SESSION_TYPE=X11 ${expressvpnClient}/bin/expressvpn-client"
  '';

  meta = with lib; {
    description = "ExpressVPN client application";
    homepage = "https://www.expressvpn.com";
    license = licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with maintainers; [ yureien ];
  };
}
