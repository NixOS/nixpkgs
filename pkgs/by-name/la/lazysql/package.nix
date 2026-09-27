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
  version = "0.5.9";

  src = fetchFromGitHub {
    owner = "jorgerojas26";
    repo = "lazysql";
    rev = "v${version}";
    hash = "sha256-A9arRNJXJGbb1xuSknTVhNNe+KGxFdtv4Qhpe9stRF8=";
  };

  vendorHash = "sha256-g2gXH0PzleT77ycLosflk7gyHL59mFtDD/6ImWtGg7o=";

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
