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
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "jorgerojas26";
    repo = "lazysql";
    rev = "v${version}";
    hash = "sha256-APbfaAHufpEaBdXO13afmdnpSA98LhXUhYZ6TK/gazk=";
  };

  vendorHash = "sha256-ef3GngaaoNEJAOF5IlTQhTrO5P22w5p7G91TYJasfGk=";

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
