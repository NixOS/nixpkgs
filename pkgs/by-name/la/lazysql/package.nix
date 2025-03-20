{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, testers
, lazysql
, xorg ? null
, darwin ? null
}:

buildGoModule rec {
  pname = "lazysql";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "jorgerojas26";
    repo = "lazysql";
    rev = "v${version}";
    hash = "sha256-tQZ8thL3rmTtxDG0Z/DgxH1PjDL4Kxx9LXDLqVTZ7Lc=";
  };

  vendorHash = "sha256-LLOUTml/mz7edCUy82k+S5PfpFovgUTQr0BoQQXiVGs=";

  ldflags = [
   "-X main.version=${version}"
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ xorg.libX11 ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Cocoa ];

  passthru.tests.version = testers.testVersion {
    package = lazysql;
    command = "lazysql --version";
  };

  meta = with lib; {
    description = "A cross-platform TUI database management tool written in Go";
    homepage = "https://github.com/jorgerojas26/lazysql";
    license = licenses.mit;
    maintainers = with maintainers; [ kanielrkirby ];
    mainProgram = "lazysql";
  };
}
