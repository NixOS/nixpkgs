{
  stdenv,
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "filen-cli";
  version = "0.0.29";

  src = fetchFromGitHub {
    owner = "FilenCloudDienste";
    repo = "filen-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ftbRv75x6o1HgElY4oLBBe5SRuLtxdrjpjZznSCyroI=";
  };

  npmDepsHash = "sha256-a+sq0vFsk4c7bl0Nn2KfBFxyq3ZF2HPvt8d1vxegnHg=";

  postPatch = ''
    # The filen-cli repository does not contain the correct version string;
    # it is replaced during publishing in the same way:
    # https://github.com/FilenCloudDienste/filen-cli/blob/c7d5eb2a2cd6d514321992815f16475f6909af36/.github/workflows/build-and-publish.yml#L24
    substituteInPlace package.json \
      --replace-fail '"version": "0.0.0"' '"version": "${finalAttrs.version}"'
  '';

  # A special random 256-bit string called CRYPTO_BASE_KEY has to be injected
  # during build. It can be randomly generated using the generateKey.mjs
  # script, however, generating a key here will invalidate the session on every
  # rebuild, and hence we need to provide a constant key. The key below is
  # extracted from the official filen-cli releases. Example:
  # $ strings filen-cli-v0.0.29-linux-x64 | grep checkInjectedBuildInfo -A 6
  # That also makes the session data compatible with the official distribution.
  env.FILEN_CLI_CRYPTO_BASE_KEY = "f47fb2011c90d8aad21f7415d19989cea2c1ac8bc674daf36af48de8697a83e0";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/filen";
  versionCheckProgramArg = [ "--version" ];

  # Writes $HOME/Library/Application Support on darwin
  doInstallCheck = !stdenv.hostPlatform.isDarwin;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^v([0-9.]+)$" ];
  };

  meta = {
    description = "CLI tool for interacting with the Filen cloud";
    homepage = "https://github.com/FilenCloudDienste/filen-cli";
    changelog = "https://github.com/FilenCloudDienste/filen-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ eilvelia ];
    mainProgram = "filen";
  };
})
