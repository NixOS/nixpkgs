{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:
buildGoModule rec {
  pname = "snicat";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "CTFd";
    repo = "snicat";
    rev = version;
    hash = "sha256-fFlTBOz127le2Y7F9KKhbcldcyFEpAU5QiJ4VCAPs9Y=";
  };

  patches = [
    # Migrate to Go modules
    (fetchpatch {
      url = "https://github.com/CTFd/snicat/commit/098a5ce3141bae5d2e188338d78517d710d10f70.patch";
      hash = "sha256-pIdXViUz14nkvL1H3u3oFkm308XA2POtKIGZOKDO6p8=";
    })
  ];

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
