{ lib, buildGoModule, installShellFiles, fetchFromGitHub, ffmpeg, ttyd, makeWrapper }:

buildGoModule rec {
  pname = "vhs";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-t6n4uID7KTu/BqsmndJOft0ifxZNfv9lfqlzFX0ApKw=";
  };

  vendorHash = "sha256-9nkRr5Jh1nbI+XXbPj9KB0ZbLybv5JUVovpB311fO38=";

  nativeBuildInputs = [ installShellFiles makeWrapper ];
  buildInputs = [ ttyd ffmpeg ];

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  postInstall = ''
    wrapProgram $out/bin/vhs --prefix PATH : ${lib.makeBinPath [ ffmpeg ttyd ]}
    $out/bin/vhs man > vhs.1
    installManPage vhs.1
    installShellCompletion --cmd vhs \
      --bash <($out/bin/vhs completion bash) \
      --fish <($out/bin/vhs completion fish) \
      --zsh <($out/bin/vhs completion zsh)
  '';

  meta = with lib; {
    description = "A tool for generating terminal GIFs with code";
    homepage = "https://github.com/charmbracelet/vhs";
    changelog = "https://github.com/charmbracelet/vhs/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ maaslalani ];
  };
}
