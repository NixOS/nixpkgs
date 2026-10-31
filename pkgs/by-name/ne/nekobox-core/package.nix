{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nekobox-core";
  version = "5.11.28.3";

  src = fetchFromGitHub {
    owner = "qr243vbi";
    repo = "nekobox";
    rev = finalAttrs.version;
    hash = "sha256-M8gFf7s9/8IFZRDbuQNAZSoQwgEgvzdOeEkjn/7gXGY=";
    fetchSubmodules = true;
  };

  strictDeps = true;
  __structuredAttrs = true;

  modRoot = "core/server";

  vendorHash = "sha256-NoKjOaXR97OJc4VdPmXzPIJAFR0xRZ7a19s2DvvSOYk=";

  subPackages = [ "." ];

  tags = [
    "with_clash_api"
    "with_gvisor"
    "with_quic"
    "with_wireguard"
    "with_utls"
    "with_dhcp"
    "with_tailscale"
    "with_shadowtls"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/sagernet/sing-box/constant.Version=${finalAttrs.version}"
    "-X internal/godebug.defaultGODEBUG=multipathtcp=0"
    "-checklinkname=0"
  ];

  env = {
    CGO_ENABLED = 0;
  };

  preBuild = ''
    # Compile the elevated_resolvctl helper so //go:embed finds it
    $CC -O3 -s stub/elevated_resolvctl.c -o elevated_resolvctl
  '';

  meta = {
    description = "Proxy core for NekoBox/NyameBox, powered by sing-box and Thrift";
    homepage = "https://github.com/qr243vbi/nekobox";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ aliheidary1381 ];
    mainProgram = "nekobox_core";
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
  };
})
