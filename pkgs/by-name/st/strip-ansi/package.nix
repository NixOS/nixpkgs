{
  stdenv,
  buildPackages,
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  installShellFiles,
}:
let
  canRunStripAnsi = stdenv.hostPlatform.emulatorAvailable buildPackages;
  stripAnsiCompletions = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/strip-ansi-completions";
in
rustPlatform.buildRustPackage {
  pname = "strip-ansi";
  version = "0.1.0-unstable-2024-09-01";

  src = fetchFromGitHub {
    owner = "KSXGitHub";
    repo = "strip-ansi-cli";
    rev = "60dbdbc22b41f743c237cb75b11e72cf7884b792";
    hash = "sha256-FvozEjNWXE1XEIq/06JehES7LVKoWmzIoaB4fD1kUsY=";
  };

  cargoHash = "sha256-FNtU3FqoFdHIQJNHhIR25zrhjEenj1okfHfVGvprph0=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString canRunStripAnsi ''
    installShellCompletion --cmd strip-ansi \
      --bash <(${stripAnsiCompletions} bash) \
      --fish <(${stripAnsiCompletions} fish) \
      --zsh <(${stripAnsiCompletions} zsh)
  '';

  meta = {
    homepage = "https://github.com/KSXGitHub/strip-ansi-cli";
    description = "Strip ANSI escape sequences from text";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers._9999years ];
    mainProgram = "strip-ansi";
  };

  passthru.updateScript = nix-update-script { };
}
