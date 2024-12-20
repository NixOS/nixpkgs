{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  piknik,
}:

buildGoModule rec {
  pname = "piknik";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "piknik";
    rev = version;
    hash = "sha256-3yvr2H1a9YtgOEEBwn1HlGXIWFzRwQPBw9+KQxW3/jo=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = piknik;
      version = "v${version}";
    };
  };

  meta = with lib; {
    description = "Copy/paste anything over the network";
    homepage = "https://github.com/jedisct1/piknik";
    changelog = "https://github.com/jedisct1/piknik/blob/${src.rev}/ChangeLog";
    license = licenses.bsd2;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "piknik";
  };
}
