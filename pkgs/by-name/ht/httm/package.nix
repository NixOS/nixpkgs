{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "httm";
  version = "0.51.1";

  src = fetchFromGitHub {
    owner = "kimono-koans";
    repo = "httm";
    rev = finalAttrs.version;
    hash = "sha256-tyzVidS4xHeTkbZ4inIGOmSGFFBKHwHYcQqZDppl/ss=";
  };

  cargoHash = "sha256-RWa46WAf/Mlb4UTygpeWbbPkMA3Mkhrv+uwkfeVHeUo=";

  nativeBuildInputs = [ installShellFiles ];

  postPatch = ''
    chmod +x scripts/*.bash
    patchShebangs scripts/*.bash
  '';

  postInstall = ''
    installManPage httm.1

    installShellCompletion --cmd httm \
      --zsh scripts/httm-key-bindings.zsh

    for script in scripts/*.bash; do
      install -Dm755 "$script" "$out/bin/$(basename "$script" .bash)"
    done

    install -Dm644 README.md $out/share/doc/README.md
  '';

  meta = {
    description = "Interactive, file-level Time Machine-like tool for ZFS/btrfs";
    homepage = "https://github.com/kimono-koans/httm";
    changelog = "https://github.com/kimono-koans/httm/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ wyndon ];
    mainProgram = "httm";
  };
})
