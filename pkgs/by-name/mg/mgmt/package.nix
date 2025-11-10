{
  augeas,
  buildGoModule,
  git,
  gotools,
  fetchFromGitHub,
  lib,
  libvirt,
  libxml2,
  nex,
  pkg-config,
  ragel,
}:

buildGoModule (final: {
  pname = "mgmt";
  version = "1.0.1";
  hash = "sha256-uYDXqxNQCnMC3g435OFpylMVeO2zuhVn2kJVltd2zWU=";
  vendorHash = "sha256-XZTDqN5nQqze41Y/jOhT3mFHXeR2oPjXpz7CJuPOi8k=";

  src = fetchFromGitHub {
    owner = "purpleidea";
    repo = "mgmt";
    tag = "${final.version}";
    hash = "${final.hash}";
    deepClone = true;
    fetchSubmodules = true;
    leaveDotGit = true;
    postFetch = ''
      git describe --match '[0-9]*\.[0-9]*\.[0-9]*' --tags --dirty --always > $out/COMMIT_SVERSION
      git describe --match '[0-9]*\.[0-9]*\.[0-9]*' --tags --abbrev=0 > $out/COMMIT_VERSION
      rm -rf .git
    '';
  };

  # patching must be done in prebuild, so it is shared with goModules
  # see https://github.com/NixOS/nixpkgs/issues/208036
  preBuild = ''
    for file in `find -name Makefile -type f`; do
      substituteInPlace $file --replace-warn "/usr/bin/env " ""
    done

    for file in `find -name "*.sh" -type f`; do
      patchShebangs $file
    done

    substituteInPlace Makefile --replace-fail "shell git describe --match '[0-9]*\.[0-9]*\.[0-9]*' --tags --dirty --always" "shell cat COMMIT_SVERSION"
    substituteInPlace Makefile --replace-fail "shell git describe --match '[0-9]*\.[0-9]*\.[0-9]*' --tags --abbrev=0" "shell cat COMMIT_VERSION"

    make funcgen lang resources
  '';

  buildInputs = [
    augeas
    libvirt
    libxml2
  ];

  nativeBuildInputs = [
    git
    gotools
    nex
    pkg-config
    ragel
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.program=mgmt"
    "-X main.version=${final.version}"
  ];

  subPackages = [ "." ];

  meta = with lib; {
    description = "Next generation distributed, event-driven, parallel config management";
    homepage = "https://mgmtconfig.com";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ urandom ];
    mainProgram = "mgmt";
  };
})
