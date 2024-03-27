{ lib
, buildGoModule
, fetchFromGitHub
, iptables
,
}:
buildGoModule rec {
  pname = "portmaster";
  version = "1.6.5";
  CGO_ENABLED = 0;

  ldflags =
    let
      BUILD_PATH = "github.com/safing/portbase/info";
    in
    [
      "-X ${BUILD_PATH}.commit=v${version}"
      "-X ${BUILD_PATH}.buildOptions="
      "-X ${BUILD_PATH}.buildUser=nixpkgs"
      "-X ${BUILD_PATH}.buildHost=hydra"
      "-X ${BUILD_PATH}.buildDate=31.10.2023"
      "-X ${BUILD_PATH}.buildSource=${src.gitRepoUrl}"
    ];

  src = fetchFromGitHub {
    owner = "safing";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FstAaj/dstIrUCP/BDr3FbA/LB8gtVeLkf64jEcbSB8=";
  };

  vendorHash = "sha256-jnw8eBBc5FQPVHJfHCgoBFObK1lQvqZtcVVBNBUg63Q=";

  runtimeDependencies = [ iptables ];

  postPatch = ''
    substituteInPlace updates/main.go --replace 'DisableSoftwareAutoUpdate = false' 'DisableSoftwareAutoUpdate = true'
  '';

  # integration tests require root access
  doCheck = false;

  meta = with lib; {
    description = "A free and open-source application firewall that does the heavy lifting for you";
    homepage = "https://safing.io";
    license = licenses.agpl3;
    maintainers = with maintainers; [ nyanbinary syntax626 ];
  };
}
