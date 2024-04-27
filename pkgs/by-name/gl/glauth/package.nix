{ lib
, fetchFromGitHub
, buildGoModule
, oath-toolkit
, openldap
}:

buildGoModule rec {
  pname = "glauth";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "glauth";
    repo = "glauth";
    rev = "v${version}";
    hash = "sha256-FOhtL8nIm5kuKRxFtkrDyUU2z1K22ZdHaes3GY0KmfQ=";
  };

  vendorHash = "sha256-MfauZRufl3kxr1fqatxTmiIvLJ+5JhbpSnbTHiujME8=";

  nativeCheckInputs = [
    oath-toolkit
    openldap
  ];

  modRoot = "v2";

  # Disable go workspaces to fix build.
  env.GOWORK = "off";

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
