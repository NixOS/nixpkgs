{
  lib,
  buildGoModule,
<<<<<<< HEAD
  fetchFromGitea,
=======
  fetchFromGitHub,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nix-update-script,
}:

buildGoModule rec {
  pname = "go-errorlint";
<<<<<<< HEAD
  version = "1.9.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "polyfloyd";
    repo = "go-errorlint";
    rev = "v${version}";
    hash = "sha256-79hbXvLnlry2j1mmeHoEx1PRIRd0iRbzN6BDnUyFV+4=";
  };

  vendorHash = "sha256-U/19X5iY7IHOHkbTADT4ueCJBPh/ryI4PCfg8ZbMLzU=";
=======
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "polyfloyd";
    repo = "go-errorlint";
    rev = "v${version}";
    hash = "sha256-jczsgZAC90f2Kkrwpb9oeoK1HtlFDLOjqlexn9v5ojk=";
  };

  vendorHash = "sha256-smOu92BigepCH02qm2Im3T65nUoR/IYhWTjhnjRPppA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };
<<<<<<< HEAD

  meta = {
    description = "Source code linter that can be used to find code that will cause problems with Go's error wrapping scheme";
    homepage = "https://codeberg.org/polyfloyd/go-errorlint";
    changelog = "https://codeberg.org/polyfloyd/go-errorlint/src/tag/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Source code linter that can be used to find code that will cause problems with Go's error wrapping scheme";
    homepage = "https://github.com/polyfloyd/go-errorlint";
    changelog = "https://github.com/polyfloyd/go-errorlint/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      meain
      polyfloyd
    ];
    mainProgram = "go-errorlint";
  };
}
