{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  writeScript,
}:

let
  commitHash = "9d021bf61a094a5eac6ae3084ceed2dda4700a73"; # matches tag release
  shortCommitHash = builtins.substring 0 7 commitHash;
in
buildGoModule rec {
  pname = "copywrite";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "copywrite";
    tag = "v${version}";
    hash = "sha256-TGis7rreRen+vk3tUDehRkyas4xrBBxKlA70+VqoGWY=";
  };

  vendorHash = "sha256-Qxp6BwN/Y6Xb1BwFGT/T8WYsXGPgN27mzoTE0i6cS1Q=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/hashicorp/copywrite/cmd.version=${version}"
    "-X github.com/hashicorp/copywrite/cmd.commit=${shortCommitHash}"
  ];

  env.CGO_ENABLED = 0;

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/copywrite completion bash > copywrite.bash
    $out/bin/copywrite completion zsh > copywrite.zsh
    $out/bin/copywrite completion fish > copywrite.fish
    installShellCompletion copywrite.{bash,zsh,fish}
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = writeScript "update-copywrite" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq nix-update

    set -eu -o pipefail

    gh_metadata="$(curl -sS https://api.github.com/repos/hashicorp/copywrite/tags)"
    version="$(echo "$gh_metadata" | jq -r '.[] | .name' | sort --version-sort | tail -1)"
    commit_hash="$(echo "$gh_metadata" | jq -r --arg ver "$version" '.[] | select(.name == $ver).commit.sha')"

    filename="$(nix-instantiate --eval -E "with import ./. {}; (builtins.unsafeGetAttrPos \"version\" copywrite).file" | tr -d '"')"
    sed -i "s/commitHash = \"[^\"]*\"/commitHash = \"$commit_hash\"/" $filename

    nix-update copywrite
  '';

  meta = {
    description = "Automate copyright headers and license files at scale";
    mainProgram = "copywrite";
    homepage = "https://github.com/hashicorp/copywrite";
    changelog = "https://github.com/hashicorp/copywrite/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ dvcorreia ];
  };
}
