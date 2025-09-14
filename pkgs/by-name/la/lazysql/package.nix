{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  testers,
  lazysql,
  xorg ? null,
  darwin ? null,
}:

buildGoModule rec {
  pname = "lazysql";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "jorgerojas26";
    repo = "lazysql";
    rev = "v${version}";
    hash = "sha256-M6G0Bp9s1XhgZL9BZDzbJmUmE+UHidpsGIaNt1i7CGw=";
  };

  vendorHash = "sha256-NGwCTEh1/5dJWOCSe18FZYYu8v7Mj6MWVEWyNNA1T68=";

  ldflags = [
    "-X main.version=${version}"
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ xorg.libX11 ];

  passthru.tests.version = testers.testVersion {
    package = lazysql;
    command = "lazysql --version";
  };

  meta = with lib; {
    description = "Cross-platform TUI database management tool written in Go";
    homepage = "https://github.com/jorgerojas26/lazysql";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "lazysql";
  };
}
