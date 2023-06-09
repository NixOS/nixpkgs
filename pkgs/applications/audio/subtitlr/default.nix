{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "Subtitlr";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "yoanbernabeu";
    repo = pname;
    rev = version;
    hash = "sha256-1EjOpWVTp7CqwqSJAhqicvY2crzw1n7Id+TIwYrSQAs=";
  };

  vendorHash = "sha256-ZgJCk9vbbQ0dcYSdKm0Cbw2AmwjpMvGb5zJkgbD+xig=";

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd Subtitlr \
      --bash <($out/bin/Subtitlr completion bash) \
      --fish <($out/bin/Subtitlr completion fish) \
      --zsh <($out/bin/Subtitlr completion zsh)
  '';

  meta = with lib; {
    description = "This application, a subtitle generator for YouTube, utilizes OpenAI's Whisper API.";
    homepage = "https://github.com/yoanbernabeu/Subtitlr/";
    license = licenses.mit;
    maintainers = with maintainers; [ qjoly ];
  };
}
