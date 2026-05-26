{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "hyprkeys";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "hyprland-community";
    repo = "Hyprkeys";
    rev = "v${finalAttrs.version}";
    hash = "sha256-u2NTSth9gminIEcbxgGm/2HHyzuwf/YPNQV4VzR14Kk=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  vendorHash = "sha256-JFvC9V0xS8SZSdLsOtpyTrFzXjYAOaPQaJHdcnJzK3s=";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd hyprkeys \
      --bash <($out/bin/hyprkeys completion bash) \
      --fish <($out/bin/hyprkeys completion fish) \
      --zsh <($out/bin/hyprkeys completion zsh)
  '';

  meta = {
    description = "Simple, scriptable keybind retrieval utility for Hyprland";
    homepage = "https://github.com/hyprland-community/Hyprkeys";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      NotAShelf
      donovanglover
    ];
    mainProgram = "hyprkeys";
  };
})
