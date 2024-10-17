{
  lib,
  buildGoModule,
  fetchFromGitHub,
  iptables,
}:

buildGoModule rec {
  pname = "portmaster";
  version = "1.6.23";

  src = fetchFromGitHub {
    owner = "safing";
    repo = "portmaster";
    rev = "v${version}";
    hash = "sha256-N7JljpWp6p9BsOI8Fh0sII0GzaBuhmTM/KBGAjZ8I2s=";
  };

  postPatch = ''
    substituteInPlace service/updates/main.go --replace-fail 'DisableSoftwareAutoUpdate = false' 'DisableSoftwareAutoUpdate = true'
  '';

  vendorHash = "sha256-HWoLfAWfZeHcVCp0q/AxJ3q/1KzOpoft2TZwaxORTL8=";

  CGO_ENABLED = 0;

  runtimeDependencies = [ iptables ];

  ldflags =
    let
      BUILD_PATH = "github.com/safing/portbase/info";
    in
    [
      "-X ${BUILD_PATH}.commit=v${version}"
      "-X ${BUILD_PATH}.buildOptions="
      "-X ${BUILD_PATH}.buildUser=nixpkgs"
      "-X ${BUILD_PATH}.buildHost=hydra"
      "-X ${BUILD_PATH}.buildDate=30.08.2024"
      "-X ${BUILD_PATH}.buildSource=${src.gitRepoUrl}"
    ];

  # integration tests require root access
  doCheck = false;

  meta = {
    changelog = "https://github.com/safing/portmaster/releases/tag/v${version}";
    description = "Free and open-source application firewall that does the heavy lifting for you";
    homepage = "https://safing.io";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      nyanbinary
      sntx
    ];
  };
}
