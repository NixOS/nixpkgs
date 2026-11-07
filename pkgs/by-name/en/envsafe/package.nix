{
  lib,
  buildDubPackage,
  fetchFromGitHub,
  versionCheckHook,
}:

buildDubPackage (finalAttrs: {
  pname = "envsafe";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "dev-centr";
    repo = "envsafe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TRShUixS39oIGaplZhxiWgXFcOdn3KYNdQ7PTlbKE1E=";
  };

  # envsafe has no dub dependencies
  dubLock = {
    dependencies = { };
  };

  doCheck = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/envsafe -t $out/bin
    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Edit .env files safely from scripts and AI agents without exposing secret values";
    homepage = "https://github.com/dev-centr/envsafe";
    changelog = "https://github.com/dev-centr/envsafe/blob/v${finalAttrs.version}/CHANGELOG.adoc";
    license = lib.licenses.mit;
    mainProgram = "envsafe";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
