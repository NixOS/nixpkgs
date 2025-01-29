{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:

let
  pname = "pinact";
  version = "1.2.0";
  src = fetchFromGitHub {
    owner = "suzuki-shunsuke";
    repo = "pinact";
    tag = "v${version}";
    hash = "sha256-OmWt4EyUHZyQDIj1Uro+bnC29MNi6wlXO2ksRP84F2U=";
  };
  mainProgram = "pinact";
in
buildGoModule {
  inherit pname version src;

  vendorHash = "sha256-sZv91EYksNmMhWbT/5PUQTM2gND/8b4ORVfMNtlAI2A=";

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

  subPackages = [
    "cmd/pinact"
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
