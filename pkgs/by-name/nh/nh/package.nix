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
}:
let
  version = "3.6.0";
  runtimeDeps = [
    nvd
    nix-output-monitor
  ];
in
rustPlatform.buildRustPackage {
  inherit version;
  pname = "nh";

  src = fetchFromGitHub {
    owner = "viperML";
    repo = "nh";
    tag = "v${version}";
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

  preFixup = ''
    mkdir completions
    $out/bin/nh completions --shell bash > completions/nh.bash
    $out/bin/nh completions --shell zsh > completions/nh.zsh
    $out/bin/nh completions --shell fish > completions/nh.fish

    installShellCompletion completions/*
  '';

  postFixup = ''
    wrapProgram $out/bin/nh \
      --prefix PATH : ${lib.makeBinPath runtimeDeps}
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-Csh8M5BquAD2vUYIu0nNWSvznTZxno1WxvkEhBVN+9c=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Yet another nix cli helper";
    homepage = "https://github.com/viperML/nh";
    license = lib.licenses.eupl12;
    mainProgram = "nh";
    maintainers = with lib.maintainers; [
      drupol
      viperML
    ];
  };
}
