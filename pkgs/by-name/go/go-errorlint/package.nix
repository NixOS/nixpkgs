{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "go-errorlint";
  version = "1.8.0";

  src = fetchFromGitHub {
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
  meta = with lib; {
    description = "Source code linter that can be used to find code that will cause problems with Go's error wrapping scheme";
    homepage = "https://github.com/polyfloyd/go-errorlint";
    changelog = "https://github.com/polyfloyd/go-errorlint/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      meain
      polyfloyd
    ];
    mainProgram = "go-errorlint";
  };
}
