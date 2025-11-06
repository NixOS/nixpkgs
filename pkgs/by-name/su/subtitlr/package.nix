{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "Subtitlr";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "yoanbernabeu";
    repo = "Subtitlr";
    rev = version;
    hash = "sha256-PbeQzNkFj4eSg/zhk8bXij36DvJ9+g22kF5TqdX5O04=";
  };

  vendorHash = "sha256-ZgJCk9vbbQ0dcYSdKm0Cbw2AmwjpMvGb5zJkgbD+xig=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd Subtitlr \
      --bash <($out/bin/Subtitlr completion bash) \
      --fish <($out/bin/Subtitlr completion fish) \
      --zsh <($out/bin/Subtitlr completion zsh)
  '';

  meta = with lib; {
    description = "This application, a subtitle generator for YouTube, utilizes OpenAI's Whisper API";
    homepage = "https://github.com/yoanbernabeu/Subtitlr/";
    license = licenses.mit;
    maintainers = with maintainers; [ qjoly ];
    mainProgram = "Subtitlr";
  };
}
