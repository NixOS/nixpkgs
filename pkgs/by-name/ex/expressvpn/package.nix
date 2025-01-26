{
  autoPatchelfHook,
  buildFHSEnv,
  dpkg,
  fetchurl,
  inotify-tools,
  lib,
  stdenvNoCC,
  sysctl,
  writeScript,
}:

let
  pname = "expressvpn";
  clientVersion = "3.52.0";
  clientBuild = "2";
  version = lib.strings.concatStringsSep "." [
    clientVersion
    clientBuild
  ];

  expressvpnBase = stdenvNoCC.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://www.expressvpn.works/clients/linux/expressvpn_${version}-1_amd64.deb";
      hash = "sha256-cDZ9R+MA3FXEto518bH4/c1X4W9XxgTvXns7zisylew=";
    };

    nativeBuildInputs = [
      dpkg
      autoPatchelfHook
    ];

    dontConfigure = true;
    dontBuild = true;

    unpackPhase = ''
      runHook preUnpack
      dpkg --fsys-tarfile $src | tar --extract
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      mv usr/ $out/
      runHook postInstall
    '';
  };

  expressvpndFHS = buildFHSEnv {
    inherit pname version;

    # When connected, it directly creates/deletes resolv.conf to change the DNS entries.
    # Since it's running in an FHS environment, it has no effect on actual resolv.conf.
    # Hence, place a watcher that updates host resolv.conf when FHS resolv.conf changes.
    runScript = writeScript "${pname}-wrapper" ''
      cp /host/etc/resolv.conf /etc/resolv.conf;
      while inotifywait /etc 2>/dev/null;
      do
        cp /etc/resolv.conf /host/etc/resolv.conf;
      done &
      expressvpnd --client-version ${clientVersion} --client-build ${clientBuild}
    '';

    # expressvpnd binary has hard-coded the path /sbin/sysctl hence below workaround.
    extraBuildCommands = ''
      mkdir -p sbin
      chmod +w sbin
      ln -s ${sysctl}/bin/sysctl sbin/sysctl
    '';

    # The expressvpnd binary also uses hard-coded paths to the other binaries and files
    # it ships with, hence the FHS environment.

    targetPkgs =
      pkgs: with pkgs; [
        expressvpnBase
        inotify-tools
        iproute2
      ];
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share
    ln -s ${expressvpnBase}/bin/expressvpn $out/bin
    ln -s ${expressvpndFHS}/bin/expressvpnd $out/bin
    ln -s ${expressvpnBase}/share/{bash-completion,doc,man} $out/share/
    runHook postInstall
  '';

  meta = with lib; {
    description = "CLI client for ExpressVPN";
    homepage = "https://www.expressvpn.com";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ yureien ];
  };
}
