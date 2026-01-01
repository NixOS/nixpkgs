{
  lib,
  stdenv,
  ttyd,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule rec {
  pname = "clive";
<<<<<<< HEAD
  version = "0.12.16";
=======
  version = "0.12.15";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "koki-develop";
    repo = "clive";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-bZzK7RLAStRb9R3V/TK6tZV6yv1C7MGslAhhpWDzdWk=";
  };

  vendorHash = "sha256-BDspmaATLIfwyqxwJNJ24vpEETUWGVbobHWD2NRaOi4=";
=======
    hash = "sha256-WOcqcyhyv72tNmm7mETjboStesfFfVVAmN2ZdLFd1Uc=";
  };

  vendorHash = "sha256-QfHCrou7Lr1CrRQqvLEnWTtQk8aDigkm4SBArLjMkyo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  subPackages = [ "." ];
  buildInputs = [ ttyd ];
  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  ldflags = [
    "-X github.com/koki-develop/clive/cmd.version=v${version}"
  ];

  postInstall = ''
    wrapProgram $out/bin/clive --prefix PATH : ${ttyd}/bin
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd clive \
      --bash <($out/bin/clive completion bash) \
      --fish <($out/bin/clive completion fish) \
      --zsh <($out/bin/clive completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doinstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Automates terminal operations";
    homepage = "https://github.com/koki-develop/clive";
    changelog = "https://github.com/koki-develop/clive/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ misilelab ];
    mainProgram = "clive";
  };
}
