{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-secdump";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "jfjallid";
    repo = "go-secdump";
    rev = "refs/tags/${version}";
    hash = "sha256-RdbrxnyP9QKkrWRLxnWljlwjJHbK++f/U0WdyB9XDc0=";
  };

  vendorHash = "sha256-RvbK0ps/5Jg/IAk71WGYEcjM6LrbCSkUueSOUFeELis=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Tool to remotely dump secrets from the Windows registry";
    homepage = "https://github.com/jfjallid/go-secdump";
    changelog = "https://github.com/jfjallid/go-secdump/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "go-secdump";
  };
}
