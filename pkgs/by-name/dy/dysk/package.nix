{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dysk";
  version = "3.6.0b";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "dysk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XkZ21dy6mIStRVqkqESSO6apD6SEeuyYDSsjBdY2+Mg=";
  };

  cargoHash = "sha256-PGHcQZCGwy/yzMrLbz1eO7zlvJI0vrRMKtj3ap13fD0=";

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
