{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "bkt-bitbucket";
  version = "0.33.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "avivsinai";
    repo = "bitbucket-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/2PMnKaSMs18ydoBsEkjsdF+XLh1gO7sg8py3av0U1M=";
  };

  vendorHash = "sha256-JiON9OzaHPKJExoaO1WFqhw6RPQsywD4znap/6rJ4t0=";

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
