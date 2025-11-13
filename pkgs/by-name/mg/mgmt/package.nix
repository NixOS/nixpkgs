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
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "purpleidea";
    repo = "mgmt";
    tag = finalAttrs.version;
    hash = "sha256-Qi9KkWzFOqmUp5CSHxzQabQ8bVnBbxxKS/W6aLBTv6k=";
  };

  vendorHash = "sha256-XZTDqN5nQqze41Y/jOhT3mFHXeR2oPjXpz7CJuPOi8k=";

  postPatch = ''
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
      urandom
      karpfediem
    ];
    mainProgram = "mgmt";
  };
})
