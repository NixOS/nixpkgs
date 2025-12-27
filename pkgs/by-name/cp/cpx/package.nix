{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  git,
  nix-update-script,
  versionCheckHook,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "cpx";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "ozacod";
    repo = "cpx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XJ89H1qJ+tlFdbDFmyPXWcccGmw3j9qhZNFnve8KwIk=";
  };

  vendorHash = "sha256-7HPy923jn8UOl9qSmynyGacLoZfAJMwDNhGchekGiC4=";

  sourceRoot = "${finalAttrs.src.name}/cpx";

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ git ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cpx \
      --bash <($out/bin/cpx completion bash) \
      --fish <($out/bin/cpx completion fish) \
      --zsh <($out/bin/cpx completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cargo-like C++ project manager";
    longDescription = ''
      Batteries-included CLI for C++ that unifies the fragmented C++ ecosystem. It provides a cohesive, Cargo-like experience for managing projects, dependencies, and builds, regardless of your underlying build system.
    '';
    downloadPage = "https://github.com/ozacod/cpx";
    homepage = "https://cpx-dev.vercel.app/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "cpx";
    platforms = lib.platforms.all;
  };
})
