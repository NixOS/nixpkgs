{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "spiffe-vault";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "philips-labs";
    repo = "spiffe-vault";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KwfsusCrh+IlgipFFALnJWfw8LJucThT4p3j+XKk84s=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      # '0000-00-00T00:00:00Z'
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-lNKcnYh2BaDzimIZuzUWA6Qwn+/Jqi1UpLKupQUpVMQ=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/philips-labs/spiffe-vault/cmd/spiffe-vault/cli.GitVersion=v${finalAttrs.version}"
    "-X github.com/philips-labs/spiffe-vault/cmd/spiffe-vault/cli.gitTreeState=clean"
  ];

  preBuild = ''
    ldflags+=" -X github.com/philips-labs/spiffe-vault/cmd/spiffe-vault/cli.gitCommit=$(cat COMMIT)"
    ldflags+=" -X \"github.com/philips-labs/spiffe-vault/cmd/spiffe-vault/cli.buildDate=$(cat SOURCE_DATE_EPOCH)\""
  '';

  preCheck = ''
    # tests expect version ldflags not to be set
    unset ldflags
  '';

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  versionCheckProgramArg = "version";

  meta = {
    description = "Integrates Spiffe and Vault to have secretless authentication";
    homepage = "https://github.com/philips-labs/spiffe-vault";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jk ];
    mainProgram = "spiffe-vault";
  };
})
