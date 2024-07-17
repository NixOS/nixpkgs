{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-camo";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "cactus";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xNdikp3Kd/VAzn7QjqIrNvifFI0mMTJ5U+zk+QbJAk0=";
  };

  vendorHash = "sha256-xN0FJntfQ2V2IsxD8dEi0vR+psnjGR7G6+ssxNTuzc4=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.ServerVersion=${version}"
  ];

  preCheck = ''
    # requires network access
    rm pkg/camo/proxy_{,filter_}test.go
  '';

  meta = with lib; {
    description = "Camo server is a special type of image proxy that proxies non-secure images over SSL/TLS";
    homepage = "https://github.com/cactus/go-camo";
    changelog = "https://github.com/cactus/go-camo/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "go-camo";
    maintainers = with maintainers; [ viraptor ];
  };
}
