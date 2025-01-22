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
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "jorgerojas26";
    repo = "lazysql";
    rev = "v${version}";
    hash = "sha256-W07C5EqBz+PgtRTJPGmuvoO8wf9t0RWi1toQzeyAq2I=";
  };

  vendorHash = "sha256-HPfk9jWNwL4C4CIrh5IJrA9v+EhaWba+lbZbIuERpkU=";

  ldflags = [
   "-X main.version=${version}"
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ xorg.libX11 ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Cocoa ];

  passthru.tests.version = testers.testVersion {
    package = lazysql;
    command = "lazysql version";
  };

  meta = with lib; {
    description = "A cross-platform TUI database management tool written in Go";
    homepage = "https://github.com/jorgerojas26/lazysql";
    license = licenses.mit;
    maintainers = with maintainers; [ kanielrkirby ];
    mainProgram = "lazysql";
  };
}
