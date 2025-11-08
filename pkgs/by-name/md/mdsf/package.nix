{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  installShellFiles,
}:
let
  pname = "mdsf";
  version = "0.10.8";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "hougesen";
    repo = "mdsf";
    tag = "v${version}";
    hash = "sha256-mvD4eBUIulPr4e7jj2As05svDH2BXJwSrWSOfMFJMzE=";
  };

  cargoHash = "sha256-atSGHGaRlXdHKvW1Gv23D6aBiBdjByg3sLUCXVqQyDY=";

  # many tests fail for various reasons of which most depend on the build sandbox
  doCheck = false;

  nativeBuildInputs = [
    installShellFiles
  ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd mdsf \
      --bash <($out/bin/mdsf completions bash) \
      --zsh <($out/bin/mdsf completions zsh) \
      --fish <($out/bin/mdsf completions fish) \
      --nushell <($out/bin/mdsf completions nushell)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Format markdown code blocks using your favorite tools";
    homepage = "https://github.com/hougesen/mdsf";
    changelog = "https://github.com/hougesen/mdsf/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "mdsf";
  };
}
