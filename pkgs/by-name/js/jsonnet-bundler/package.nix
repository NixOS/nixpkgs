{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "jsonnet-bundler";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "jsonnet-bundler";
    repo = "jsonnet-bundler";
    rev = "v${version}";
    hash = "sha256-VaYfjDSDst1joN2MnDVdz9SGGMamhYxfNM/a2mJf8Lo=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  meta = {
    description = "Jsonnet package manager";
    homepage = "https://github.com/jsonnet-bundler/jsonnet-bundler";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ preisschild ];
    mainProgram = "jb";
  };
}
