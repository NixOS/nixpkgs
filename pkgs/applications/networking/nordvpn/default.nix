{ autoPatchelfHook, buildFHSEnv, dpkg, fetchurl, lib, stdenv, sysctl
, iptables, iproute2, procps, cacert, libxml2, libidn2, zlib, wireguard-tools }:

let
  pname = "nordvpn";
  version = "3.15.5";

  nordVPNBase = stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url =
        "https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn_${version}_amd64.deb";
      hash = "sha256-7IvtpWiwVFaOc9/2NzG9mAGaWAeBZXNPdqCumdslawI=";
    };

    buildInputs = [ libxml2 libidn2 ];
    nativeBuildInputs = [ dpkg autoPatchelfHook stdenv.cc.cc.lib ];

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
      mv var/ $out/
      mv etc/ $out/
      runHook postInstall
    '';
  };

  nordVPNfhs = buildFHSEnv {
    name = "nordvpnd";
    runScript = "nordvpnd";

    # hardcoded path to /sbin/ip
    targetPkgs = pkgs:
      with pkgs; [
        nordVPNBase
        sysctl
        iptables
        iproute2
        procps
        cacert
        libxml2
        libidn2
        zlib
        wireguard-tools
      ];
  };

in stdenv.mkDerivation {
  inherit pname version;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share $out/lib/systemd/system
    ln -s ${nordVPNBase}/bin/nordvpn $out/bin
    ln -s ${nordVPNfhs}/bin/nordvpnd $out/bin
    ln -s ${nordVPNBase}/share/{bash-completion,doc,man} $out/share/
    ln -s ${nordVPNBase}/var $out/
    runHook postInstall
  '';

  meta = with lib; {
    description = "CLI client for NordVPN";
    homepage = "https://www.nordvpn.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ LuisChDev ];
    platforms = [ "x86_64-linux" ];
  };
}
