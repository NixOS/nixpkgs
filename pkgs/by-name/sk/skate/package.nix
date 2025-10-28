{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "skate";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "skate";
    rev = "v${version}";
    hash = "sha256-Ihzcto41ltV5LQjLP9AF5XGl5b6QDbgZ/q4BMzfrDC8=";
  };

  proxyVendor = true;
  vendorHash = "sha256-H0j0za/+pNEYQAfTvLcECU7jt+2HJMJRcK+n/GbLNO0=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  meta = with lib; {
    description = "Personal multi-machine syncable key value store";
    homepage = "https://github.com/charmbracelet/skate";
    changelog = "https://github.com/charmbracelet/skate/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [
      figsoda
      penguwin
    ];
    mainProgram = "skate";
  };
}
