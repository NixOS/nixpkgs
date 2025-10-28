{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
  nix-update-script,
}:
buildGoModule rec {
  pname = "mdtsql";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "noborus";
    repo = "mdtsql";
    tag = "v${version}";
    hash = "sha256-D9suWLrVQOztz0rRjEo+pjxQlGWOOsk3EUbkN9yuriY=";
  };

  vendorHash = "sha256-psXnLMhrApyBjDY/S4WwIM1GLczyn4dUmX2fWSTq7mQ=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd mdtsql \
        --bash <(${emulator} $out/bin/mdtsql completion bash) \
        --fish <(${emulator} $out/bin/mdtsql completion fish) \
        --zsh <(${emulator} $out/bin/mdtsql completion zsh)
    ''
  );

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Execute SQL to markdown table and convert to other format";
    homepage = "https://github.com/noborus/mdtsql";
    changelog = "https://github.com/noborus/mdtsql/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    mainProgram = "mdtsql";
  };
}
