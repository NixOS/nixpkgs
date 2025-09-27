{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  testers,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "s-search";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "zquestz";
    repo = "s";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bcJeNUGTcXAwB+/xly3AMJE3BTjqiC6QvuqgfDgZZrk=";
  };

  vendorHash = "sha256-0E/9fONanSxb2Tv5wKIpf1J/A6Hdge23xy3r6pFyV9E=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd s \
      --bash <($out/bin/s --completion bash) \
      --fish <($out/bin/s --completion fish) \
      --zsh <($out/bin/s --completion zsh)
  '';

  passthru = {
    # `versionCheckHook` fails due to the program requires `sh` to be available in `PATH`
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "s --version";
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Web search from the terminal";
    longDescription = ''
      Command-line tool that generates a search query link and opens it in the
      browser of your choice.
    '';
    homepage = "https://github.com/zquestz/s";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      yzx9
    ];
    mainProgram = "s";
  };
})
