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
  v2ray,
  iptables,
  gawk,
  util-linux,
  liboqs,
}:
buildGoModule (finalAttrs: {
  pname = "ivpn-service";
  version = "3.15.6";

  buildInputs = [
    wirelesstools
    (finalAttrs.passthru.liboqs)
  ];
  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "ivpn";
    repo = "desktop-app";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C24klcr10i0lki74eNfJ4bappdIttp3S4FGg1wkAGcY=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  modRoot = "daemon";
  subPackages = [ "." ];
  vendorHash = "sha256-YDvZVmResoieSBIp/yuZDvI9GSz3M6Bi5KksHOljuR0=";

  proxyVendor = true; # .c file

  patches = [ ./permissions.patch ];

  postPatch = ''
    substituteInPlace daemon/service/platform/platform_linux.go \
      --replace-fail 'openVpnBinaryPath = "/usr/sbin/openvpn"' \
      'openVpnBinaryPath = "${openvpn}/bin/openvpn"' \
      --replace-fail 'routeCommand = "/sbin/ip route"' \
      'routeCommand = "${iproute2}/bin/ip route"'

    substituteInPlace daemon/netinfo/netinfo_linux.go \
      --replace-fail 'retErr := shell.ExecAndProcessOutput(log, outParse, "", "/sbin/ip", "route")' \
      'retErr := shell.ExecAndProcessOutput(log, outParse, "", "${iproute2}/bin/ip", "route")'

    substituteInPlace daemon/service/platform/platform_linux_release.go \
      --replace-fail 'installDir := "/opt/ivpn"' "installDir := \"$out\"" \
      --replace-fail 'obfsproxyStartScript = path.Join(installDir, "obfsproxy/obfs4proxy")' \
      'obfsproxyStartScript = "${lib.getExe obfs4}"' \
      --replace-fail 'wgBinaryPath = path.Join(installDir, "wireguard-tools/wg-quick")' \
      'wgBinaryPath = "${wireguard-tools}/bin/wg-quick"' \
      --replace-fail 'wgToolBinaryPath = path.Join(installDir, "wireguard-tools/wg")' \
      'wgToolBinaryPath = "${wireguard-tools}/bin/wg"' \
      --replace-fail 'dnscryptproxyBinPath = path.Join(installDir, "dnscrypt-proxy/dnscrypt-proxy")' \
      'dnscryptproxyBinPath = "${dnscrypt-proxy}/bin/dnscrypt-proxy"' \
      --replace-fail 'v2rayBinaryPath = path.Join(installDir, "v2ray/v2ray")' \
      'v2rayBinaryPath = "${v2ray}/bin/v2ray"' \
      --replace-fail 'kemHelperBinaryPath = path.Join(installDir, "kem/kem-helper")' \
      'kemHelperBinaryPath = "${placeholder "out"}/bin/kem-helper"'
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ivpn/desktop-app/daemon/version._version=${finalAttrs.version}"
    "-X github.com/ivpn/desktop-app/daemon/version._time=1970-01-01"
  ];

  postBuild = ''
    $CC -O2 -pthread \
        References/common/kem-helper/main.c \
        References/common/kem-helper/base64.c \
        -loqs -Wl,-z,stack-size=5242880 \
        -o kem-helper
  '';

  postInstall = ''
    mv $out/bin/{daemon,ivpn-service}
    install -Dm755 kem-helper $out/bin/kem-helper
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
          iproute2
        ]
      }
  '';

  # IVPN pins this to an older incompatible version, so we vendor it at that
  # Lives in passthru so end-users can override it
  passthru.liboqs = liboqs.overrideAttrs (
    final: prev: {
      version = "0.10.0";
      src = fetchFromGitHub {
        owner = "open-quantum-safe";
        repo = "liboqs";
        tag = "${final.version}";
        hash = "sha256-BFDa5NUr02lFPcT4Hnb2rjGAi+2cXvh1SHLfqX/zLlI=";
      };
      # the main derivations patches don't apply onto the older version
      patches = [ ];
      # manually do what the main derivations pkg-config patch does (unbreak invalid path)
      postPatch = ''
        substituteInPlace src/liboqs.pc.in \
          --replace-fail 'libdir=''${prefix}/@CMAKE_INSTALL_LIBDIR@' \
          'libdir=@CMAKE_INSTALL_FULL_LIBDIR@' \
          --replace-fail 'includedir=''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@' \
          'includedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@'
      '';
      # This matches IVPNs build script at $src/daemon/References/common/kem-helper/build.sh
      cmakeFlags = (prev.cmakeFlags or [ ]) ++ [
        "-DOQS_USE_OPENSSL=OFF"
        "-DOQS_MINIMAL_BUILD=KEM_kyber_1024;KEM_classic_mceliece_348864"
      ];
    }
  );

  meta = {
    description = "Official IVPN Desktop app service daemon";
    homepage = "https://www.ivpn.net/apps";
    changelog = "https://github.com/ivpn/desktop-app/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      kilyanni
    ];
    mainProgram = "ivpn-service";
  };
})
