{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  btrfs-progs,
  lvm2,
}:

buildGoModule rec {
  pname = "dockle";
  version = "0.4.15";

  src = fetchFromGitHub {
    owner = "goodwithtech";
    repo = "dockle";
    rev = "v${version}";
    hash = "sha256-YoDgTKhXpN4UVF/+NDFxaEFwMj81RJaqfjr29t1UdLY=";
  };

  vendorHash = "sha256-RMuTsPgqQoD2pdEaflNOOBZK5R8LbtcBzpAGocG8OGk=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    btrfs-progs
    lvm2
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/goodwithtech/dockle/pkg.version=${version}"
  ];

  preCheck = ''
    # Remove tests that use networking
    rm pkg/scanner/scan_test.go
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/dockle --help
    $out/bin/dockle --version | grep "dockle version ${version}"
    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://containers.goodwith.tech";
    changelog = "https://github.com/goodwithtech/dockle/releases/tag/v${version}";
    description = "Container Image Linter for Security";
    mainProgram = "dockle";
    longDescription = ''
      Container Image Linter for Security.
      Helping build the Best-Practice Docker Image.
      Easy to start.
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jk ];
  };
}
