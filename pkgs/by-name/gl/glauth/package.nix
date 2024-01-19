{ lib
, fetchFromGitHub
, buildGoModule
, oath-toolkit
, openldap
}:

buildGoModule rec {
  pname = "glauth";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "glauth";
    repo = "glauth";
    rev = "v${version}";
    hash = "sha256-XYNNR3bVLNtAl+vbGRv0VhbLf+em8Ay983jqcW7KDFU=";
  };

  vendorHash = "sha256-SFmGgxDokIbVl3ANDPMCqrB0ck8Wyva2kSV2mgNRogo=";

  nativeCheckInputs = [
    oath-toolkit
    openldap
  ];

  modRoot = "v2";

  # Disable go workspaces to fix build.
  env.GOWORK = "off";

  # Fix this build error:
  #   main module (github.com/glauth/glauth/v2) does not contain package github.com/glauth/glauth/v2/vendored/toml
  excludedPackages = [ "vendored/toml" ];

  # Based on ldflags in <glauth>/Makefile.
  ldflags = [
    "-s"
    "-w"
    "-X main.GitClean=1"
    "-X main.LastGitTag=v${version}"
    "-X main.GitTagIsCommit=1"
  ];

  # Tests fail in the sandbox.
  doCheck = false;

  meta = with lib; {
    description = "A lightweight LDAP server for development, home use, or CI";
    homepage = "https://github.com/glauth/glauth";
    license = licenses.mit;
    maintainers = with maintainers; [ bjornfor christoph-heiss ];
    mainProgram = "glauth";
  };
}
