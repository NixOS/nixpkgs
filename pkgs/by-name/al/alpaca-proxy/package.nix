{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "alpaca-proxy";
  version = "2.0.10";

  src = fetchFromGitHub {
    owner = "samuong";
    repo = "alpaca";
    rev = "v${version}";
    hash = "sha256-1CMuZl1bVlofogPwA2wRuQPlXNE2EM1B8rDDDaJGq64=";
  };

  vendorHash = "sha256-N9qpyCQg6H1v/JGJ2wCxDX+ZTM9x6/BM6wQ26xC+dlE=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.BuildVersion=v${version}"
  ];

  postInstall = ''
    # executable is renamed to alpaca-proxy, to avoid collision with the alpaca python application
    mv $out/bin/alpaca $out/bin/alpaca-proxy
  '';

  meta = with lib; {
    description = "HTTP forward proxy with PAC and NTLM authentication support";
    homepage = "https://github.com/samuong/alpaca";
    changelog = "https://github.com/samuong/alpaca/releases/tag/v${src.rev}";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ _1nv0k32 ];
    mainProgram = "alpaca-proxy";
  };
}
