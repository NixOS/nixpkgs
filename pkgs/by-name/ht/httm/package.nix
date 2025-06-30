{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "httm";
  version = "0.48.4";

  src = fetchFromGitHub {
    owner = "kimono-koans";
    repo = "httm";
    rev = version;
    hash = "sha256-636Two3kGtzpx6gQfvBKhhz5BQflP8joYpw0CY5UnoA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-95xqzwFcTusL50Ue6dsM2BhD6J2Fi/qsrGQYniFVVd4=";

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
