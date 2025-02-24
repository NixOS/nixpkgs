{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-minimock";
  version = "3.4.5";

  src = fetchFromGitHub {
    owner = "gojuno";
    repo = "minimock";
    rev = "v${version}";
    hash = "sha256-D5U1KfWXe9qtcFQKDoISC6Hq5axMO37WsyFjpPOyyo4=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  vendorHash = "sha256-MN/tHT+vjLswUxe+c3FZn+S0l+fklqnIvj4BnPfbOjw=";

  doCheck = true;

  subPackages = [
    "cmd/minimock"
    "."
  ];

  meta = with lib; {
    homepage = "https://github.com/gojuno/minimock";
    description = "Golang mock generator from interfaces";
    license = licenses.mit;
    maintainers = with maintainers; [ svrana ];
    mainProgram = "minimock";
  };
}
