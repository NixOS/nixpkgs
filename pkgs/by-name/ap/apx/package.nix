{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  distrobox,
  podman,
  writableTmpDirAsHomeHook,
  curl,
  jq,
  common-updater-scripts,
  writeShellScript,
}:

buildGoModule (finalAttrs: {
  pname = "apx";
  version = "2.4.5";
  versionConfig = "1.0.0";

  src = fetchFromGitHub {
    owner = "Vanilla-OS";
    repo = "apx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0Rfj7hrH26R9GHOPPVdCaeb1bfAw9KnPpJYXyiei90U=";
  };

  # Official Vanilla APX configs (stacks + package-managers)
  configsSrc = fetchFromGitHub {
    owner = "Vanilla-OS";
    repo = "vanilla-apx-configs";
    tag = "v${finalAttrs.versionConfig}";
    hash = "sha256-cCXmHkRjcWcpMtgPVtQF5Q76jr1Qt2RHSLtWLQdq+aE=";
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
    "-X 'main.Version=v${finalAttrs.version}'"
  ];

  postPatch = ''
    substituteInPlace config/apx.json \
      --replace-fail "/usr/share/apx/distrobox/distrobox" "${distrobox}/bin/distrobox" \
      --replace-fail "/usr/share/apx" "$out/share/apx"
    substituteInPlace settings/config.go \
      --replace-fail "/usr/share/apx/" "$out/share/apx/"
  '';

  postInstall = ''
    # Base configuration of apx
    install -Dm444 config/apx.json -t $out/share/apx/

    # Install official Vanilla configs (same as install script)
    install -d $out/share/apx
    cp -r ${finalAttrs.configsSrc}/stacks $out/share/apx/
    cp -r ${finalAttrs.configsSrc}/package-managers $out/share/apx/

    # Man pages, documentation, license
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

  passthru.updateScript = writeShellScript "update-apx" ''
    set -euo pipefail
        PATH=${
          lib.makeBinPath [
            curl
            jq
            common-updater-scripts
          ]
        }:$PATH

    echo "Fetching latest version for vanilla-apx-configs..."
    LATEST_CONFIG=$(curl -s https://api.github.com/repos/Vanilla-OS/vanilla-apx-configs/releases/latest | jq -r .tag_name | sed 's/^v//')

    echo "Updating versionConfig to $LATEST_CONFIG..."
    update-source-version apx "$LATEST_CONFIG" --version-key=versionConfig --source-key=configsSrc

    echo "Updating main apx package..."
    nix-update apx
  '';

  meta = {
    description = "Vanilla OS package manager";
    longDescription = ''
      Apx is the Vanilla OS package manager that allows you to install packages
      from multiple sources inside managed containers without altering the host system.

      Note: This package requires Podman to be enabled in your NixOS configuration.
      Add the following to your configuration.nix:

        virtualisation.podman.enable = true;
        environment.systemPackages = with pkgs; [ apx ];
    '';
    homepage = "https://github.com/Vanilla-OS/apx";
    changelog = "https://github.com/Vanilla-OS/apx/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      dit7ya
      chewblacka
      masrlinu
    ];
    mainProgram = "apx";
  };
})
