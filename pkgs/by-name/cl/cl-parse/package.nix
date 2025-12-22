{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  buildPackages,
}:

buildGoModule (finalAttrs: {
  pname = "cl-parse";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "scottmckendry";
    repo = "cl-parse";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SZcr8fBTlA0Ibmx/8vVf1jmNkRTPC5nRtM2mOoFF/rg=";
  };

  vendorHash = "sha256-/SL6FE1rX1xkJ6vpVJUms7HUnLNY6qq66jaYUbGWKsM=";
  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall =
    let
      cl-parse =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          placeholder "out"
        else
          buildPackages.cl-parse;
    in
    ''
      installShellCompletion --cmd cl-parse \
        --bash <(${cl-parse}/bin/cl-parse completion bash) \
        --fish <(${cl-parse}/bin/cl-parse completion fish) \
        --zsh <(${cl-parse}/bin/cl-parse completion zsh)
    '';

  meta = {
    description = "Parse and query changelog files as though they were structured data";
    homepage = "https://github.com/scottmckendry/cl-parse";
    changelog = "https://github.com/scottmckendry/cl-parse/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ scottmckendry ];
    mainProgram = "cl-parse";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
