{
  stdenv,
  lib,
  rustPlatform,
  installShellFiles,
  makeBinaryWrapper,
  darwin,
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
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k8rz5RF1qi7RXzQYWGbw5pJRNRFIdX85SIYN+IHiVL4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  preFixup = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      mkdir completions
      ${emulator} $out/bin/nh completions --shell bash > completions/nh.bash
      ${emulator} $out/bin/nh completions --shell zsh > completions/nh.zsh
      ${emulator} $out/bin/nh completions --shell fish > completions/nh.fish

      installShellCompletion completions/*
    ''
  );

  postFixup = ''
    wrapProgram $out/bin/nh \
      --prefix PATH : ${lib.makeBinPath runtimeDeps}
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-Csh8M5BquAD2vUYIu0nNWSvznTZxno1WxvkEhBVN+9c=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Yet another nix cli helper";
    homepage = "https://github.com/nix-community/nh";
    license = lib.licenses.eupl12;
    mainProgram = "nh";
    maintainers = with lib.maintainers; [
      drupol
      viperML
    ];
  };
})
