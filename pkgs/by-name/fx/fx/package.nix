{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "fx";
  version = "39.2.0";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = "fx";
    tag = finalAttrs.version;
    hash = "sha256-sQnawn5My511IsxBMh6r06R2aLKGmF0ndP1alr/Y8vw=";
  };

  vendorHash = "sha256-C4TqFRECIFzc6TyAJ2yj97t2BVHXBovIV3iIjNhm7ek=";

  ldflags = [ "-s" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd fx \
      --bash <($out/bin/fx --comp bash) \
      --fish <($out/bin/fx --comp fish) \
      --zsh <($out/bin/fx --comp zsh)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = [ "HOME" ];

  meta = {
    changelog = "https://github.com/antonmedv/fx/releases/tag/${finalAttrs.src.tag}";
    description = "Terminal JSON viewer";
    homepage = "https://github.com/antonmedv/fx";
    license = lib.licenses.mit;
    mainProgram = "fx";
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
})
