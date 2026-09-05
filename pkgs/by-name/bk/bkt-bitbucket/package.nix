{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "bkt-bitbucket";
  version = "0.31.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "avivsinai";
    repo = "bitbucket-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-amowjmW0exFB/YN1rYfy/KvST+TfzOAAocoRzR9oRRs=";
  };

  vendorHash = "sha256-9wjEq4a5snJJ4uD4y+O3wJ15vVNs6Mcu8JVG43n94To=";

  subPackages = [ "cmd/bkt" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/avivsinai/bitbucket-cli/internal/build.versionFromLdflags=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/bkt";
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for Bitbucket Cloud and Bitbucket Data Center, installing the `bkt` binary";
    longDescription = ''
      A gh-style command-line interface for Bitbucket Cloud and Bitbucket
      Data Center: repositories, pull requests, branches, pipelines and more.
      Unrelated to the `bkt` subprocess-caching tool and to swisscom's
      bitbucket-cli.
    '';
    homepage = "https://github.com/avivsinai/bitbucket-cli";
    changelog = "https://github.com/avivsinai/bitbucket-cli/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "bkt";
    maintainers = with lib.maintainers; [ avivsinai ];
    platforms = with lib.platforms; linux ++ darwin;
  };
})
