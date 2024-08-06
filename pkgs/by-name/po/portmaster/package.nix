{
  lib,
  buildGoModule,
  fetchFromGitHub,
  iptables,
}:
buildGoModule rec {
  pname = "portmaster";
  version = "1.6.18";

  src = fetchFromGitHub {
    owner = "safing";
    repo = "portmaster";
    rev = "v${version}";
    hash = "sha256-K/HEDVWgjW//m+CqIiL+xgKRObNMOtjY1Z8myTkDXSw=";
  };

  postPatch = ''
    substituteInPlace service/updates/main.go --replace 'DisableSoftwareAutoUpdate = false' 'DisableSoftwareAutoUpdate = true'
  '';

  vendorHash = "sha256-/sxjCSPhsZZwQv7w1bKiBoBnS7jozJIbyu8S64TOe4Q=";

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
      "-X ${BUILD_PATH}.buildDate=01.08.2024"
      "-X ${BUILD_PATH}.buildSource=${src.gitRepoUrl}"
    ];

  # integration tests require root access
  doCheck = false;

  meta = {
    description = "Free and open-source application firewall that does the heavy lifting for you";
    homepage = "https://safing.io";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      nyanbinary
      sntx
    ];
  };
}
