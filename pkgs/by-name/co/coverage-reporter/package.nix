{
  lib,
  crystal_1_19,
  fetchFromGitHub,
  versionCheckHook,
  ...
}:
crystal_1_19.buildCrystalPackage rec {
  pname = "coverage-reporter";
  version = "0.6.22";

  src = fetchFromGitHub {
    owner = "coverallsapp";
    repo = "coverage-reporter";
    tag = "v${version}";
    hash = "sha256-9h7nshdO7qc5XdAMoELwKkFtIwTa5IMi0AvC6lL5fyk=";
  };

  shardsFile = ./shards.nix;

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/coveralls $out/bin/coveralls
    runHook postInstall
  '';

  doCheck = false;
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    changelog = "https://github.com/coverallsapp/coverage-reporter/releases/tag/${src.tag}";
    description = "Self-contained, universal coverage uploader binary";
    homepage = "https://github.com/coverallsapp/coverage-reporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      quadradical
      chrjabs
    ];
    mainProgram = "coveralls";
  };
}
