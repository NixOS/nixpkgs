{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  distrobox,
  podman,
  writableTmpDirAsHomeHook,
}:

buildGoModule rec {
  pname = "apx";
  version = "2.4.5";

  src = fetchFromGitHub {
    owner = "Vanilla-OS";
    repo = "apx";
    tag = "v${version}";
    hash = "sha256-0Rfj7hrH26R9GHOPPVdCaeb1bfAw9KnPpJYXyiei90U=";
  };

  vendorHash = "sha256-RoZ6sXbvIHfQcup9Ba/PpzS0eytKdX4WjDUlgB3UjfE=";

  # podman needed for apx to not error when building shell completions
  nativeBuildInputs = [
    installShellFiles
    podman
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  ldflags = [
    "-s"
    "-w"
    "-X 'main.Version=v${version}'"
  ];

  postPatch = ''
    substituteInPlace config/apx.json \
      --replace-fail "/usr/share/apx/distrobox/distrobox" "${distrobox}/bin/distrobox" \
      --replace-fail "/usr/share/apx" "$out/bin/apx"
    substituteInPlace settings/config.go \
      --replace-fail "/usr/share/apx/" "$out/share/apx/"
  '';

  postInstall = ''
    install -Dm444 config/apx.json -t $out/share/apx/
    installManPage man/man1/*
    install -Dm444 README.md -t $out/share/docs/apx
    install -Dm444 COPYING.md $out/share/licenses/apx/LICENSE

    # apx command now works (for completions)
    # though complains "Error: no such file or directory"
    installShellCompletion --cmd apx \
      --bash <($out/bin/apx completion bash) \
      --fish <($out/bin/apx completion fish) \
      --zsh <($out/bin/apx completion zsh)
  '';

  meta = {
    description = "Vanilla OS package manager";
    homepage = "https://github.com/Vanilla-OS/apx";
    changelog = "https://github.com/Vanilla-OS/apx/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      dit7ya
      chewblacka
    ];
    mainProgram = "apx";
  };
}
