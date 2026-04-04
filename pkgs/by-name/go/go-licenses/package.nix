{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  go,
  installShellFiles,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  pname = "go-licenses";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "go-licenses";
    tag = "v${finalAttrs.version}";
    hash = "sha256-byKuUf8XMyXjAHZUANaBVAc6c2Jz9mEEdRxAy69P2QM=";
  };

  vendorHash = "sha256-AYbx/DmYnbjJ2iqx34t/dUsthTjJ+YDvfxxCl/cJenI=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  subPackages = [ "." ];

  allowGoReference = true;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd go-licenses \
      --bash <("$out/bin/go-licenses" completion bash) \
      --fish <("$out/bin/go-licenses" completion fish) \
      --zsh  <("$out/bin/go-licenses" completion zsh)

    # workaround empty output when GOROOT differs from built environment
    # see https://github.com/google/go-licenses/issues/149
    wrapProgram "$out/bin/go-licenses" \
      --set GOROOT '${go}/share/go'
  '';

  # Tests require internet connection
  doCheck = false;

  meta = {
    changelog = "https://github.com/google/go-licenses/releases/tag/v${finalAttrs.version}";
    description = "Reports on the licenses used by a Go package and its dependencies";
    mainProgram = "go-licenses";
    homepage = "https://github.com/google/go-licenses";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ Luflosi ];
  };
})
