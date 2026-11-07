{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dysk";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "dysk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jOtr5juFXj3GG5rD/l+G0OLsjiPohzfs7zpZrNsEHYQ=";
  };

  cargoHash = "sha256-PqVLIVh3N3C4JBdwbtlAu5ITjQuMb19QLjdnZx7elRs=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage $releaseDir/build/*/out/dysk.1
    installShellCompletion $releaseDir/build/*/out/{dysk.bash,dysk.fish,_dysk}
  '';

  meta = {
    description = "Get information on your mounted disks";
    homepage = "https://github.com/Canop/dysk";
    changelog = "https://github.com/Canop/dysk/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      koral
      osbm
    ];
    mainProgram = "dysk";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
