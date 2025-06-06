{
  stdenv,
  lib,
  rustPlatform,
  installShellFiles,
  makeBinaryWrapper,
  fetchFromGitHub,
  nix-update-script,
  nvd,
  nix-output-monitor,
  buildPackages,
}:
let
  runtimeDeps = [
    nvd
    nix-output-monitor
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nh";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AC47bSPkt+R2mY5M1LvWHDr6+wtT//ddwCFj95iuF4g=";
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
    ''
  );

  postFixup = ''
    wrapProgram $out/bin/nh \
      --prefix PATH : ${lib.makeBinPath runtimeDeps}
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-FCE50Ali6r6s8UE2m7uT6U+LQmMHztB/8OFwmbLNkvo=";

  passthru.updateScript = nix-update-script { };

  env.NH_REV = finalAttrs.src.tag;

  meta = {
    changelog = "https://github.com/nix-community/nh/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Yet another nix cli helper";
    homepage = "https://github.com/nix-community/nh";
    license = lib.licenses.eupl12;
    mainProgram = "nh";
    maintainers = with lib.maintainers; [
      drupol
      NotAShelf
      viperML
    ];
  };
})
