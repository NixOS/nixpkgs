{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:

let
  pname = "pinact";
  version = "1.1.0";
  src = fetchFromGitHub {
    owner = "suzuki-shunsuke";
    repo = "pinact";
    tag = "v${version}";
    hash = "sha256-FOWlCKhMZhxWRb6079aSbTO3RR1Da7ZfjHb5N/ULl8o=";
  };
  mainProgram = "pinact";
in
buildGoModule {
  inherit pname version src;

  vendorHash = "sha256-Cdo24F1ewrGhXHC+gOh/HNlCQhJfTYBMqLWoL8HedYE=";

  env.CGO_ENABLED = 0;

  doCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${mainProgram}";
  versionCheckProgramArg = [ "version" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version} -X main.commit=v${version}"
  ];

  meta = {
    inherit mainProgram;
    description = "Pin GitHub Actions versions";
    homepage = "https://github.com/suzuki-shunsuke/pinact";
    changelog = "https://github.com/suzuki-shunsuke/pinact/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kachick ];
  };
}
