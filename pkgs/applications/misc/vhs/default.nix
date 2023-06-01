{ lib, stdenv, buildGoModule, installShellFiles, fetchFromGitHub, ffmpeg, ttyd, chromium, makeWrapper }:

buildGoModule rec {
  pname = "vhs";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-d7oHPe1R0KZaVTTxmed27VZ2PphiQfy7CXYhVKHWUhE=";
  };

  vendorHash = "sha256-jrXdbxH5hJrd5yyVsTOeIYJciJ6wVTydkD6aSuWYKPQ=";

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  postInstall = ''
    wrapProgram $out/bin/vhs --prefix PATH : ${lib.makeBinPath (lib.optionals stdenv.isLinux [ chromium ] ++ [ ffmpeg ttyd ])}
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
