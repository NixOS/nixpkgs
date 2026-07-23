{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "datadog-pup";
  version = "1.7.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "pup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zXb6SM6ylFVoIg+M7loNvPT45mda1okTSXslfLzOHpQ=";
  };

  cargoHash = "sha256-b3aDH3UOa7VSiLEGZkr8EIvsZ9WnADnHOL8EOnAKHkM=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  doCheck = false;
  doInstallCheck = true;

  meta = {
    description = "CLI for Datadog's observability platform";
    homepage = "https://github.com/DataDog/pup";
    changelog = "https://github.com/DataDog/pup/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bobvanderlinden ];
    mainProgram = "pup";
    platforms = lib.platforms.linux;
  };
})
