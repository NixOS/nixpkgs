{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "lazyssh";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Adembc";
    repo = "lazyssh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6halWoLu9Vp6XU57wAQXaWBwKzqpnyoxJORzCbyeU5Q=";
  };

  vendorHash = "sha256-OMlpqe7FJDqgppxt4t8lJ1KnXICOh6MXVXoKkYJ74Ks=";

  ldflags = [
    "-X=main.version=${finalAttrs.version}"
    "-X=main.gitCommit=v${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/lazyssh
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-based SSH manager";
    homepage = "https://github.com/Adembc/lazyssh";
    changelog = "https://github.com/Adembc/lazyssh/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "lazyssh";
  };
})
