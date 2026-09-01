{
  lib,
  buildGo126Module,
  buildPackages,
  cronet-go,
  fetchFromGitHub,
  systemd,
}:

buildGo126Module (finalAttrs: {
  pname = "sing-box-daemon";
  version = "1.14.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "SagerNet";
    repo = "sing-box";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1v9bgM2H439ZoSkomv5dmT5SNrkuyOJ1iFFPlYPsW/k=";
  };

  vendorHash = "sha256-Bl73SkmnOyh5kULctDaxcOzXsYXRY2DOt80ME2+lBJo=";

  tags = [
    "with_gvisor"
    "with_quic"
    "with_dhcp"
    "with_wireguard"
    "with_utls"
    "with_acme"
    "with_clash_api"
    "with_tailscale"
    "with_ccm"
    "with_ocm"
    "with_cloudflared"
    "with_naive_outbound"
    "with_usbip"
    "with_openvpn"
    "with_openconnect"
    "badlinkname"
    "tfogo_checklinkname0"
  ];

  subPackages = [ "experimental/boxdd" ];

  env = {
    CGO_ENABLED = 1;
    CGO_LDFLAGS = "-fuse-ld=lld";
  };

  nativeBuildInputs = [ buildPackages.rustc.llvmPackages.bintools ];
  buildInputs = [ cronet-go ];

  ldflags = [
    "-X=github.com/sagernet/sing-box/constant.Version=${finalAttrs.version}"
    "-X=runtime.godebugDefault=multipathtcp=0,tlssha1=1,tlsunsafeekm=1"
    "-checklinkname=0"
    "-s"
    "-w"
  ];

  postPatch = ''
    substituteInPlace experimental/boxdd/cmd_service_linux.go \
      --replace-fail 'exec.Command("systemctl",' 'exec.Command("${systemd}/bin/systemctl",'
  '';

  postConfigure = ''
    pushd vendor/github.com/sagernet/cronet-go
    chmod -R u+w .
    cp -r ${cronet-go}/. .
    patch -p1 < ${./cronet-go.patch}
    substituteInPlace internal/cronet/loader_unix.go --subst-var out
    popd
  '';

  postInstall = ''
    mv "$out/bin/boxdd" "$out/bin/sing-box-daemon"
    install -Dm644 LICENSE "$out/share/licenses/sing-box-daemon/LICENSE"
  '';

  doCheck = false;

  meta = {
    description = "Privileged sing-box daemon for the desktop client";
    homepage = "https://github.com/SagerNet/sing-box";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ snemeow ];
    mainProgram = "sing-box-daemon";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
