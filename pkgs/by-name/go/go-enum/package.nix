{
  buildGoModule,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "go-enum";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "abice";
    repo = "go-enum";
    tag = "v${version}";
    hash = "sha256-VZH7xLEDqU8N7oU3tOWVdTABEQEp2mlh1NtTg22hzco=";
  };

  vendorHash = "sha256-bqJ+KBUsJzTNqeshq3eXFImW/JYL7zmCEwcy2xQHJeE=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
    "-X main.builtBy=nix"
  ];

  meta = {
    description = "Enum generator for go";
    homepage = "https://github.com/abice/go-enum";
    license = lib.licenses.mit;
    mainProgram = "go-enum";
    maintainers = with lib.maintainers; [ Nadim147c ];
    platforms = lib.platforms.unix;
  };
}
