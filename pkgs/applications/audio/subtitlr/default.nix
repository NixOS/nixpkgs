{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "Subtitlr";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "yoanbernabeu";
    repo = pname;
    rev = version;
    hash = "sha256-fwDIE8DFVd7NRhi8bBmFxrmGdT2ZtSFWBaynV+xz3ms=";
  };

  vendorHash = "sha256-t92nz42sv8bE0JIkSFB2+WBz1Um8kcRSotpXcPIy3eQ=";

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
