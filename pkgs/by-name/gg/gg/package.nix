{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:
buildGoModule rec{
  pname = "gg";
  version = "0.2.19";

  src = fetchFromGitHub {
    owner = "mzz2017";
    repo = "gg";
    rev = "v${version}";
    hash = "sha256-DXW0NtFYvcCX4CgMs5/5HPaO9f9eFtw401wmJdCbHPU=";
  };

  vendorHash = "sha256-fnM4ycqDyruCdCA1Cr4Ki48xeQiTG4l5dLVuAafEm14=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd gg \
    --bash completion/bash/gg \
    --fish completion/fish/gg.fish \
    --zsh completion/zsh/_gg
  '';

  meta = with lib; {
    homepage = "https://github.com/mzz2017/gg";
    changelog = "https://github.com/mzz2017/gg/releases/tag/${src.rev}";
    description = "Command-line tool for one-click proxy in your research and development";
    license = licenses.agpl3Only;
    mainProgram = "gg";
    maintainers = with maintainers; [ oluceps ];
    platforms = platforms.linux;
  };
}
