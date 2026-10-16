{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  writableTmpDirAsHomeHook,
  viceroy,
}:

buildGoModule (finalAttrs: {
  pname = "fastly";
  version = "16.2.0";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UCk12PYpY/dnP8HvO5UB4RH3zmaYu+gc/bz62+9fJ7o=";
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse --short HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  subPackages = [ "cmd/fastly" ];

  vendorHash = "sha256-LaWk1RIoVoOOaZ6QG2Zw4corUffi91bMOSfsRt0L/ZM=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    writableTmpDirAsHomeHook
  ];

  preBuild = ''
    ldflags+=" -X github.com/fastly/cli/pkg/revision.GitCommit=$(cat COMMIT)"
  '';

  ldflags = [
    "-s"
    "-X github.com/fastly/cli/pkg/revision.AppVersion=v${finalAttrs.version}"
    "-X github.com/fastly/cli/pkg/revision.Environment=release"
  ];

  # must embed viceroy to prevent fetching binary release on `fastly compute serve` invocation
  preFixup = ''
    wrapProgram $out/bin/fastly \
      --prefix PATH : ${lib.makeBinPath [ viceroy ]} \
      --set FASTLY_VICEROY_USE_PATH 1
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd fastly \
      --bash <($out/bin/fastly --completion-script-bash) \
      --zsh <($out/bin/fastly --completion-script-zsh)
  '';

  meta = {
    description = "Command line tool for interacting with the Fastly API";
    homepage = "https://github.com/fastly/cli";
    changelog = "https://github.com/fastly/cli/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      ereslibre
      stepbrobd
    ];
    mainProgram = "fastly";
  };
})
