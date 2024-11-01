{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-camo";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "cactus";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2iclQVkj813xW9Ff3yh5dxCun0LxsPn4YpSLeMwsNbY=";
  };

  vendorHash = "sha256-GbBFGbNxsijcUIogjSv8RcIQn6VQ+j21Qlm9eQWzTtc=";

  ldflags = [ "-s" "-w" "-X=main.ServerVersion=${version}" ];

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
