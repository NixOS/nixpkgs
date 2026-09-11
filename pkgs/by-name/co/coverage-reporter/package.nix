{
  lib,
  crystal_1_17,
  fetchFromGitHub,
  versionCheckHook,
  ...
}:
crystal_1_17.buildCrystalPackage rec {
  pname = "coverage-reporter";
  version = "0.6.18";

  src = fetchFromGitHub {
    owner = "coverallsapp";
    repo = "coverage-reporter";
    tag = "v${version}";
    hash = "sha256-X/BD3w7c7xxeozYJ41K26X3gSgFaSnM+ocoTuM44ncE=";
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
    maintainers = with lib.maintainers; [ quadradical ];
    mainProgram = "coveralls";
  };
}
