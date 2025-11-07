{
  lib,
  fetchFromGitHub,
  buildGoModule,
  go-mockery,
  versionCheckHook,
}:
buildGoModule rec {
  pname = "sesh";
  version = "2.18.2";

  nativeBuildInputs = [
    go-mockery
  ];
  src = fetchFromGitHub {
    owner = "joshmedeski";
    repo = "sesh";
    rev = "v${version}";
    hash = "sha256-ZxO6hUE1/KzcZu0G9NaCgpqy1JfPdUxlAOkqm4bpfxE=";
  };

  preBuild = ''
    mockery
  '';
  vendorHash = "sha256-GEWtbhZhgussFzfg1wNEU0Gr5zhXmwlsgH6d1cXOwvc=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

  meta = {
    description = "Smart session manager for the terminal";
    homepage = "https://github.com/joshmedeski/sesh";
    changelog = "https://github.com/joshmedeski/sesh/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gwg313
      randomdude
      t-monaghan
    ];
    mainProgram = "sesh";
  };
}
