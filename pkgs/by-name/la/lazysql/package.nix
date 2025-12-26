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
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "jorgerojas26";
    repo = "lazysql";
    rev = "v${version}";
    hash = "sha256-yy8eWhboz+9X3CZTWgqs5VuCBvW5GWnjItKuwVZe8ag=";
  };

  vendorHash = "sha256-FbAt/HsjoxqAKWQqqWN2xuyyTG2Ic4DcyEU4O0rjpQE=";

  ldflags = [
    "-X main.version=${version}"
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ xorg.libX11 ];

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
