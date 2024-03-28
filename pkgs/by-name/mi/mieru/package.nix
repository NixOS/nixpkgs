{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mieru";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "enfein";
    repo = "mieru";
    rev = "v${version}";
    hash = "sha256-G8sZqYuUV9+7iOdwYngidcECF7haAYWVaPolyDFlBKg=";
  };

  vendorHash = "sha256-Mn2cUj3Xs6nFnwMZziPdQQyfB88P+SqlWxs70WxYscM=";
  proxyVendor = true;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A socks5 / HTTP / HTTPS proxy to bypass censorship";
    homepage = "https://github.com/enfein/mieru";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ oluceps ];
    mainProgram = "mieru";
  };
}
