{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:

let
  pname = "pinact";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "suzuki-shunsuke";
    repo = "pinact";
    rev = "v${version}";
    hash = "sha256-fOmQDfqG1aWzpL80Nc8JA6HWQR+z9mhqtwU4rC2g2Gg=";
  };
  mainProgram = "pinact";
in
buildGoModule {
  inherit pname version src;

  vendorHash = "sha256-AFlkzs5mL/x9CwfF2apLcQbiu60GD33oFH6lQDHAL1M=";

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
    "-X main.version=${version} -X main.commit=${src.rev}"
  ];

  meta = with lib; {
    inherit mainProgram;
    description = "Pin GitHub Actions versions";
    homepage = "https://github.com/suzuki-shunsuke/pinact";
    changelog = "https://github.com/suzuki-shunsuke/pinact/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = [ maintainers.kachick ];
  };
}
