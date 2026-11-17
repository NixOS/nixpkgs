{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hyperfine";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "hyperfine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VCan4dLZAG3bOPlZfh2ydmrQHR9K/74zbOyOXRZGMUA=";
  };

  cargoHash = "sha256-gKoD573Lz9FChPoNeC9R3xn228aMrz+BA9sXZXuKF2k=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage doc/hyperfine.1

    installShellCompletion \
      $releaseDir/build/hyperfine-*/out/hyperfine.{bash,fish} \
      --zsh $releaseDir/build/hyperfine-*/out/_hyperfine
  '';

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Command-line benchmarking tool";
    homepage = "https://github.com/sharkdp/hyperfine";
    changelog = "https://github.com/sharkdp/hyperfine/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      mdaniels5757
      thoughtpolice
    ];
    mainProgram = "hyperfine";
  };
})
