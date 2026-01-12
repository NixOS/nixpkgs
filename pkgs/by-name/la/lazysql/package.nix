{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  testers,
  lazysql,
  libx11,
  darwin ? null,
}:

buildGoModule rec {
  pname = "lazysql";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "jorgerojas26";
    repo = "lazysql";
    rev = "v${version}";
    hash = "sha256-kEGUPlFCU2kKgVJHobVP+DFmAcMc/ZDP+u0w03DnhSo=";
  };

  vendorHash = "sha256-FbAt/HsjoxqAKWQqqWN2xuyyTG2Ic4DcyEU4O0rjpQE=";

  ldflags = [
    "-X main.version=${version}"
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libx11 ];

  passthru.tests.version = testers.testVersion {
    package = lazysql;
    command = "lazysql --version";
  };

  meta = {
    description = "Cross-platform TUI database management tool written in Go";
    homepage = "https://github.com/jorgerojas26/lazysql";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "lazysql";
  };
}
