{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:

let
  pname = "pinact";
  version = "3.0.4-0";
  src = fetchFromGitHub {
    owner = "suzuki-shunsuke";
    repo = "pinact";
    tag = "v${version}";
    hash = "sha256-VQXFxN3uDGMMRu3Tr6F03tMpTkKjt3q+CyvWrLWiOd4=";
  };
  mainProgram = "pinact";
in
buildGoModule {
  inherit pname version src;

  vendorHash = "sha256-+iYNducL+tX34L5VlisqeNwvJUcuOAkEWDk/2JbfC0Q=";

  env.CGO_ENABLED = 0;

  doCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${mainProgram}";
  versionCheckProgramArg = "version";

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
