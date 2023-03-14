{ lib, buildGoModule, installShellFiles, fetchFromGitHub, ffmpeg, ttyd, chromium, makeWrapper }:

buildGoModule rec {
  pname = "vhs";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-62FS/FBhQNpj3dAfKfIUKY+IJeeaONzqRu7mG49li+o";
  };

  vendorHash = "sha256-+BLZ+Ni2dqboqlOEjFNF6oB/vNDlNRCb6AiDH1uSsLw";

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  postInstall = ''
    wrapProgram $out/bin/vhs --prefix PATH : ${lib.makeBinPath [ chromium ffmpeg ttyd ]}
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
    maintainers = with maintainers; [ maaslalani penguwin ];
  };
}
