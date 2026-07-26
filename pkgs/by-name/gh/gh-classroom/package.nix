{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
  installShellFiles,
}:
buildGoModule (finalAttrs: {
  pname = "gh-classroom";
  version = "0.1.17";

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-classroom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h/GLgqHN8dGWRCAjBOCqh5nUlj1RSx77obGZ2s1vV6o=";
  };

  vendorHash = "sha256-anYKlaODkRYee8uvaraIbMLwRqdW2xkKo1DEG8FTwtU=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd gh-classroom \
        --bash <(${emulator} $out/bin/gh-classroom --bash-completion) \
        --fish <(${emulator} $out/bin/gh-classroom --fish-completion) \
        --zsh <(${emulator} $out/bin/gh-classroom --zsh-completion)
    ''
  );

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/github/gh-classroom";
    description = "Extension for the GitHub CLI, that enhances it for educators using GitHub classroom";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _0x5a4 ];
    mainProgram = "gh-classroom";
  };
})
