{
  buildGoModule,
  fetchFromGitHub,
  lib,
  wirelesstools,
  makeWrapper,
  wireguard-tools,
  openvpn,
  obfs4,
  iproute2,
  dnscrypt-proxy,
  iptables,
  gawk,
  util-linux,
  nix-update-script,
}:

let
  version = "3.15.0";
in
buildGoModule rec {
  pname = "ivpn-service";
  inherit version;

  buildInputs = [ wirelesstools ];
  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "ivpn";
    repo = "desktop-app";
    tag = "v${version}";
    hash = "sha256-Y+oW/2WDkH/YydR+xSzEHPdCNKTmmsV4yEsju+OmDYE=";
  };

  modRoot = "daemon";
  vendorHash = "sha256-DVKSCcEeE7vI8aOYuEwk22n0wtF7MMDOyAgYoXYadwI=";

  proxyVendor = true; # .c file

  patches = [ ./permissions.patch ];

  postPatch = ''
    substituteInPlace daemon/service/platform/platform_linux.go \
      --replace 'openVpnBinaryPath = "/usr/sbin/openvpn"' \
      'openVpnBinaryPath = "${openvpn}/bin/openvpn"' \
      --replace 'routeCommand = "/sbin/ip route"' \
      'routeCommand = "${iproute2}/bin/ip route"'

    substituteInPlace daemon/netinfo/netinfo_linux.go \
      --replace 'retErr := shell.ExecAndProcessOutput(log, outParse, "", "/sbin/ip", "route")' \
      'retErr := shell.ExecAndProcessOutput(log, outParse, "", "${iproute2}/bin/ip", "route")'

    substituteInPlace daemon/service/platform/platform_linux_release.go \
      --replace 'installDir := "/opt/ivpn"' "installDir := \"$out\"" \
      --replace 'obfsproxyStartScript = path.Join(installDir, "obfsproxy/obfs4proxy")' \
      'obfsproxyStartScript = "${lib.getExe obfs4}"' \
      --replace 'wgBinaryPath = path.Join(installDir, "wireguard-tools/wg-quick")' \
      'wgBinaryPath = "${wireguard-tools}/bin/wg-quick"' \
      --replace 'wgToolBinaryPath = path.Join(installDir, "wireguard-tools/wg")' \
      'wgToolBinaryPath = "${wireguard-tools}/bin/wg"' \
      --replace 'dnscryptproxyBinPath = path.Join(installDir, "dnscrypt-proxy/dnscrypt-proxy")' \
      'dnscryptproxyBinPath = "${dnscrypt-proxy}/bin/dnscrypt-proxy"'
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ivpn/desktop-app/daemon/version._version=${version}"
    "-X github.com/ivpn/desktop-app/daemon/version._time=1970-01-01"
  ];

  postInstall = ''
    mv $out/bin/{daemon,ivpn-service}
  '';

  postFixup = ''
    mkdir -p $out/etc
    cp -r $src/daemon/References/Linux/etc/* $out/etc/
    cp -r $src/daemon/References/common/etc/* $out/etc/

    patchShebangs --build $out/etc/firewall.sh $out/etc/splittun.sh $out/etc/client.down $out/etc/client.up

    wrapProgram "$out/bin/ivpn-service" \
      --suffix PATH : ${
        lib.makeBinPath [
          iptables
          gawk
          util-linux
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Official IVPN Desktop app service daemon";
    homepage = "https://www.ivpn.net/apps";
    changelog = "https://github.com/ivpn/desktop-app/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      urandom
      blenderfreaky
    ];
    mainProgram = "ivpn-service";
  };
}
