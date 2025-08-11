{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "fx";
  version = "39.0.1";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = "fx";
    tag = finalAttrs.version;
    hash = "sha256-KVnPESE0Fp1liOZtpDgNpAggROnGHYdefAAECkbgZDE=";
  };

  vendorHash = "sha256-7x0nbgMzEJznDH6Wf5iaTYXLh/2IGUSeSVvb0UKKTOQ=";

  ldflags = [ "-s" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd fx \
      --bash <($out/bin/fx --comp bash) \
      --fish <($out/bin/fx --comp fish) \
      --zsh <($out/bin/fx --comp zsh)
  '';

  meta = {
    changelog = "https://github.com/antonmedv/fx/releases/tag/${finalAttrs.src.tag}";
    description = "Terminal JSON viewer";
    homepage = "https://github.com/antonmedv/fx";
    license = lib.licenses.mit;
    mainProgram = "fx";
    maintainers = with lib.maintainers; [ figsoda ];
  };
})
