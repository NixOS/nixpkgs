{
  lib,
  fetchFromGitHub,
  buildGoModule,
  go-mockery,
  versionCheckHook,
}:
buildGoModule rec {
  pname = "sesh";
<<<<<<< HEAD
  version = "2.20.0";
=======
  version = "2.19.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    go-mockery
  ];
  src = fetchFromGitHub {
    owner = "joshmedeski";
    repo = "sesh";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-YfgxXM8FPRAUk4jxUnQNNB8hMjiB5ZCRY2/S+OgzECs=";
=======
    hash = "sha256-mteypgCgFxgoPSh0H1kwNUm3p9F3wbRjhONdSm9Qeqs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
