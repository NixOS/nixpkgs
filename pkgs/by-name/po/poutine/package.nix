{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "poutine";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "boostsecurityio";
    repo = "poutine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DyxV8GlNbU/g6GMdOEt++oXFDq7+K4FeWTVJPUAFKk8=";
  };

  vendorHash = "sha256-Ktsk01YqBHVZDOu+Xp1p3sVDwqozl35iLYbVavpiWq0=";

  ldflags = [
    "-s"
    "-w"
  ];

  # "dagger" directory contains its own go module, which should be excluded from the build
  excludedPackages = [ "dagger" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
      --bash <($out/bin/${finalAttrs.meta.mainProgram} completion bash) \
      --fish <($out/bin/${finalAttrs.meta.mainProgram} completion fish) \
      --zsh <($out/bin/${finalAttrs.meta.mainProgram} completion zsh)
  '';

  meta = {
    description = "Security scanner that detects misconfigurations and vulnerabilities in build pipelines of repositories";
    homepage = "https://github.com/boostsecurityio/poutine";
    changelog = "https://github.com/boostsecurityio/poutine/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "poutine";
  };
})
