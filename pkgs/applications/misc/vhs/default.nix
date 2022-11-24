{ lib, buildGoModule, installShellFiles, fetchFromGitHub, ffmpeg, ttyd, makeWrapper }:

buildGoModule rec {
  pname = "vhs";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wcOLUA/U+xRwo7slnACCURQO7D0F3pFP2/SHDfEHeTA=";
  };

  vendorHash = "sha256-f8EHDxu+NWAFJx9ujzsiDhNymdEzExmdreP11gV56AI=";

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
