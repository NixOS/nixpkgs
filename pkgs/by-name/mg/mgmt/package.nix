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
buildGoModule rec {
  pname = "mgmt";
  version = "unstable-2022-10-24";

  src = fetchFromGitHub {
    owner = "purpleidea";
    repo = pname;
    rev = "d8820fa1855668d9e0f7a7829d9dd0d122b2c5a9";
    hash = "sha256-jurZvEtiaTjWeDkmCJDIFlTzR5EVglfoDxkFgOilo8s=";
  };

  # patching must be done in prebuild, so it is shared with goModules
  # see https://github.com/NixOS/nixpkgs/issues/208036
  preBuild = ''
    for file in `find -name Makefile -type f`; do
      substituteInPlace $file --replace "/usr/bin/env " ""
    done

    substituteInPlace lang/types/Makefile \
      --replace "unset GOCACHE && " ""
    patchShebangs misc/header.sh
    make lang funcgen
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
    "-X main.program=${pname}"
    "-X main.version=${version}"
  ];

  subPackages = [ "." ];

  vendorHash = "sha256-Dtqy4TILN+7JXiHKHDdjzRTsT8jZYG5sPudxhd8znXY=";

  meta = with lib; {
    description = "Next generation distributed, event-driven, parallel config management!";
    homepage = "https://mgmtconfig.com";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ urandom ];
    mainProgram = "mgmt";
  };
}
