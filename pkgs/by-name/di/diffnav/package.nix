{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  makeBinaryWrapper,
  installShellFiles,
  delta,
}:

buildGoModule (finalAttrs: {
  pname = "diffnav";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "diffnav";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hoikRqhVjbd7hH4H+f5OGq0KdIX1etAJhrRL+QsAkx8=";
  };

  vendorHash = "sha256-VNpmcniSpeocl9B+aNwLh4XPyPnYC8SXowJPYWHyzWs=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
    installShellFiles
  ];
  postInstall = ''
    wrapProgram $out/bin/diffnav \
      --prefix PATH : ${lib.makeBinPath [ delta ]}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd diffnav \
     --bash <($out/bin/diffnav completion bash) \
     --fish <($out/bin/diffnav completion fish) \
     --zsh <($out/bin/diffnav completion zsh)
  '';

  meta = {
    changelog = "https://github.com/dlvhdr/diffnav/releases/tag/${finalAttrs.src.rev}";
    description = "Git diff pager based on delta but with a file tree, à la GitHub";
    homepage = "https://github.com/dlvhdr/diffnav";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      amesgen
      matthiasbeyer
    ];
    mainProgram = "diffnav";
  };
})
