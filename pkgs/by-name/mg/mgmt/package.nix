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
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "purpleidea";
    repo = "mgmt";
    tag = finalAttrs.version;
    hash = "sha256-nLk497gGrZ664VG9/yV6tqTtwAsN8EmuAEh5Vmq95hQ=";
  };

  vendorHash = "sha256-w4j9cJwW2tnjXSnd3w3v81TwHI8tGYiImjG3LZ+Pjuc=";

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
