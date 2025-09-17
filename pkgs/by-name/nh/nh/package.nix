{
  stdenv,
  lib,
  rustPlatform,
  installShellFiles,
  makeBinaryWrapper,
  fetchFromGitHub,
  nix-update-script,
  nix-output-monitor,
  buildPackages,
}:
let
  runtimeDeps = [
    nix-output-monitor
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nh";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6n5SVO8zsdVTD691lri7ZcO4zpqYFU8GIvjI6dbxkA8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      mkdir completions

      for shell in bash zsh fish; do
        NH_NO_CHECKS=1 ${emulator} $out/bin/nh completions $shell > completions/nh.$shell
      done

      installShellCompletion completions/*

      cargo xtask man --out-dir gen
      installManPage gen/nh.1
    ''
  );

  postFixup = ''
    wrapProgram $out/bin/nh \
      --prefix PATH : ${lib.makeBinPath runtimeDeps}
  '';

  cargoHash = "sha256-cxZsePgraYevuYQSi3hTU2EsiDyn1epSIcvGi183fIU=";

  passthru.updateScript = nix-update-script { };

  env.NH_REV = finalAttrs.src.tag;

  meta = {
    changelog = "https://github.com/nix-community/nh/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Yet another nix cli helper";
    homepage = "https://github.com/nix-community/nh";
    license = lib.licenses.eupl12;
    mainProgram = "nh";
    maintainers = with lib.maintainers; [
      NotAShelf
      viperML
    ];
  };
})
