{
  lib,
  buildGoModule,
  fetchFromGitea,
  nix-update-script,
}:

buildGoModule rec {
  pname = "go-errorlint";
  version = "1.8.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "polyfloyd";
    repo = "go-errorlint";
    rev = "v${version}";
    hash = "sha256-jczsgZAC90f2Kkrwpb9oeoK1HtlFDLOjqlexn9v5ojk=";
  };

  vendorHash = "sha256-smOu92BigepCH02qm2Im3T65nUoR/IYhWTjhnjRPppA=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Source code linter that can be used to find code that will cause problems with Go's error wrapping scheme";
    homepage = "https://codeberg.org/polyfloyd/go-errorlint";
    changelog = "https://codeberg.org/polyfloyd/go-errorlint/src/tag/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      meain
      polyfloyd
    ];
    mainProgram = "go-errorlint";
  };
}
