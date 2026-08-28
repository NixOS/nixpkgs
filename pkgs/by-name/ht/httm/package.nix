{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "httm";
  version = "0.50.2";

  src = fetchFromGitHub {
    owner = "kimono-koans";
    repo = "httm";
    rev = finalAttrs.version;
    hash = "sha256-MqJ2b7JuYVWXv53DlCWulP95d1YCUN+Psx8wKgengX0=";
  };

  cargoHash = "sha256-1tQFLmAilezEiRsv6JnKJfp5AHd8DshpcOiEi+9VpRs=";

  nativeBuildInputs = [ installShellFiles ];

  postPatch = ''
    chmod +x scripts/*.bash
    patchShebangs scripts/*.bash
  '';

  postInstall = ''
    installManPage httm.1

    for script in bowie equine nicotine ounce; do
      install -Dm755 "scripts/$script.bash" "$out/bin/$script"
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
