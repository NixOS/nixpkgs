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
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "jorgerojas26";
    repo = "lazysql";
    rev = "v${version}";
    hash = "sha256-5JGSpA4tAV6/f9y58PfjGOamxRYyCKKZXecRzpvq4E0=";
  };

  vendorHash = "sha256-FyvPTqvlNtU3Yud5Pq9CRLG0xg4LIXb9CDEBvigGow8=";

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
