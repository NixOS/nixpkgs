{
  augeas,
  buildGoModule,
  fetchFromGitHub,
  gotools,
  lib,
  libvirt,
  libxml2,
  nex,
  pkg-config,
  ragel,
}:
buildGoModule (finalAttrs: {
  pname = "mgmt";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "purpleidea";
    repo = "mgmt";
    tag = finalAttrs.version;
    hash = "sha256-jVFIVlytDvfTrAzWkX+pedAq/AcLrCDFtLPx0Wc+XjM=";
  };

  vendorHash = "sha256-mMRAlqySy6dpRG86p0BHSpYn2gzE8N4sZ3qHiyuttBA=";

  proxyVendor = true;

  postPatch = ''
    rm -rf vendor
    patchShebangs misc/header.sh
  '';
  preBuild = ''
    make lang resources funcgen
  '';

  buildInputs = [
    augeas
    libvirt
    libxml2
  ];

  nativeBuildInputs = [
    gotools
    nex
    pkg-config
    ragel
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.program=${finalAttrs.pname}"
    "-X main.version=${finalAttrs.version}"
  ];

  subPackages = [ "." ];

  meta = {
    description = "Next generation distributed, event-driven, parallel config management";
    homepage = "https://mgmtconfig.com";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      karpfediem
    ];
    mainProgram = "mgmt";
    platforms = lib.platforms.linux;
  };
})
