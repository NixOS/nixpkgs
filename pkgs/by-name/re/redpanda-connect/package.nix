{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "redpanda-connect";
  version = "4.47.1";

  src = fetchFromGitHub {
    owner = "redpanda-data";
    repo = "connect";
    tag = "v${version}";
    hash = "sha256-hyOJf3b6tGB/Wycc7pE70o3pmr+V9hBA+JbDTu+bXws=";
  };

  proxyVendor = true;

  subPackages = [
    "cmd/redpanda-connect-community"
  ];

  vendorHash = "sha256-blBwp4XEuah+rCj0EuOyK4r/DXd5Hv5A7/Z2W5wPZdE=";

  # doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  passthru.updateScript = nix-update-script { };

  postInstall = ''
    ln -s $out/bin/redpanda-connect-community $out/bin/redpanda-connect
  '';

  meta = {
    description = "Fancy stream processing made operationally mundane";
    mainProgram = "redpanda-connect";
    homepage = "https://www.redpanda.com/connect";
    changelog = "https://github.com/redpanda-data/connect/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sagikazarmark ];
  };
}
