{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "snicat";
  version = "0.0.1-unstable-2024-09-05";

  src = fetchFromGitHub {
    owner = "CTFd";
    repo = "snicat";
    rev = "8c8f06e59d5aedb9a97115a4e0eafa75b17a6cdf";
    hash = "sha256-71wVth+VzEnGW8ErWmj6XjhNtVpx/q8lViIA71njwqU=";
  };

  vendorHash = "sha256-27ykI9HK1jFanxwa6QrN6ZS548JbFNSZHaXr4ciCVOE=";
  proxyVendor = true;

  ldflags = [
    "-s"
    "-X main.version=v${version}"
  ];

  postInstall = ''
    mv $out/bin/snicat $out/bin/sc
  '';

  meta = with lib; {
    description = "TLS & SNI aware netcat";
    homepage = "https://github.com/CTFd/snicat";
    license = licenses.asl20;
    mainProgram = "sc";
    maintainers = with maintainers; [ felixalbrigtsen ];
  };
}
