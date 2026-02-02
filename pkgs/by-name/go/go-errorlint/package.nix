{
  lib,
  buildGoModule,
  fetchFromCodeberg,
  nix-update-script,
}:

buildGoModule rec {
  pname = "go-errorlint";
  version = "1.9.0";

  src = fetchFromCodeberg {
    owner = "polyfloyd";
    repo = "go-errorlint";
    rev = "v${version}";
    hash = "sha256-79hbXvLnlry2j1mmeHoEx1PRIRd0iRbzN6BDnUyFV+4=";
  };

  vendorHash = "sha256-U/19X5iY7IHOHkbTADT4ueCJBPh/ryI4PCfg8ZbMLzU=";

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
