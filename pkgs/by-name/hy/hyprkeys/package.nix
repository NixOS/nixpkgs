{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "hyprkeys";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "hyprland-community";
    repo = "Hyprkeys";
    rev = "v${version}";
    hash = "sha256-u2NTSth9gminIEcbxgGm/2HHyzuwf/YPNQV4VzR14Kk=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  vendorHash = "sha256-JFvC9V0xS8SZSdLsOtpyTrFzXjYAOaPQaJHdcnJzK3s=";

  postInstall = ''
    installShellCompletion --cmd hyprkeys \
      --bash <($out/bin/hyprkeys completion bash) \
      --fish <($out/bin/hyprkeys completion fish) \
      --zsh <($out/bin/hyprkeys completion zsh)
  '';

  meta = with lib; {
    description = "A simple, scriptable keybind retrieval utility for Hyprland";
    homepage = "https://github.com/hyprland-community/Hyprkeys";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      NotAShelf
      donovanglover
    ];
    mainProgram = "hyprkeys";
  };
}
