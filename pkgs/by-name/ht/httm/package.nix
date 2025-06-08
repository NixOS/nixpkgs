{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "httm";
  version = "0.48.3";

  src = fetchFromGitHub {
    owner = "kimono-koans";
    repo = "httm";
    rev = version;
    hash = "sha256-55rUNITdz8lM0yuQQrNhXCKxwx4m7FPVhE1usEAVj0I=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Hbn+PlmJ9FiwHme3kXjvG7m2rkgR4nGnpTT04JHJrao=";

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
    changelog = "https://github.com/kimono-koans/httm/releases/tag/${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ wyndon ];
    mainProgram = "httm";
  };
}
