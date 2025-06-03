{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "httm";
  version = "0.47.1";

  src = fetchFromGitHub {
    owner = "kimono-koans";
    repo = "httm";
    rev = version;
    hash = "sha256-quIyyGz9tA0WdfpftbgPZ83YynL/9SV0jRZW+zp0voI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-cPcQ0RPuTW3z4hv9EZGOqp0SY/4HtJ3fGuelqEQwFtE=";

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

  meta = with lib; {
    description = "Interactive, file-level Time Machine-like tool for ZFS/btrfs";
    homepage = "https://github.com/kimono-koans/httm";
    changelog = "https://github.com/kimono-koans/httm/releases/tag/${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ wyndon ];
    mainProgram = "httm";
  };
}
