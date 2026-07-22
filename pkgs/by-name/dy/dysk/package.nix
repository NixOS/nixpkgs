{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dysk";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "dysk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6yjLIioul6wEocv3pzghPMWLKd5kDqCb7ezh4oFcdmU=";
  };

  cargoHash = "sha256-vpSel0bHQ40kMRfvi3YKf6oAl0f/sjK5GHxAEt6of8Y=";

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
