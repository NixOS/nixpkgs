{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  distrobox,
  podman,
}:

buildGoModule rec {
  pname = "apx";
  version = "2.4.4";

  src = fetchFromGitHub {
    owner = "Vanilla-OS";
    repo = "apx";
    rev = "v${version}";
    hash = "sha256-60z6wbbXQp7MA5l7LP/mToZftX+nbcs2Mewg5jCFwFk=";
  };

  vendorHash = "sha256-YHnPLjZWUYoARHF4V1Pm1LYdCJGubPCve0wQ5FpeXUg=";

  # podman needed for apx to not error when building shell completions
  nativeBuildInputs = [
    installShellFiles
    podman
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

    # Create a temp writable home-dir so apx outputs completions without error
    export HOME=$(mktemp -d)
    # apx command now works (for completions)
    # though complains "Error: no such file or directory"
    installShellCompletion --cmd apx \
      --bash <($out/bin/apx completion bash) \
      --fish <($out/bin/apx completion fish) \
      --zsh <($out/bin/apx completion zsh)
  '';

  meta = with lib; {
    description = "Vanilla OS package manager";
    homepage = "https://github.com/Vanilla-OS/apx";
    changelog = "https://github.com/Vanilla-OS/apx/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      dit7ya
      chewblacka
    ];
    mainProgram = "apx";
  };
}
