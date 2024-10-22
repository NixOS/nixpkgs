{ lib, fetchFromGitHub, buildGoModule, callPackage, enableWebui ? true }:

buildGoModule rec {
  pname = "rmfakecloud";
  version = "0.0.18";

  src = fetchFromGitHub {
    owner = "ddvk";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-J8oB5C5FYZTVq9zopHoL6WYpfTyiiyrQ4YSGu+2eaKw=";
  };

  vendorHash = "sha256-S43qNDAlDWhrkfSffCooveemR1Z7KXS18t97UoolgBM=";

  ui = callPackage ./webui.nix { inherit version src; };

  postPatch = if enableWebui then ''
    mkdir -p ui/build
    cp -r ${ui}/* ui/build
  '' else ''
    sed -i '/go:/d' ui/assets.go
  '';

  ldflags = [
    "-s" "-w" "-X main.version=v${version}"
  ];

  meta = with lib; {
    description = "Host your own cloud for the Remarkable";
    homepage = "https://ddvk.github.io/rmfakecloud/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ pacien martinetd ];
    mainProgram = "rmfakecloud";
  };
}
