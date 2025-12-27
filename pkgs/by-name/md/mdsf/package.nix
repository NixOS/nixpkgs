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
  version = "0.11.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "hougesen";
    repo = "mdsf";
    tag = "v${version}";
    hash = "sha256-hz28Aj4sD4/bA6T1ZUW50SzYV6dmM04vSgYwNSWyaVg=";
  };

  cargoHash = "sha256-dTQucEYGpsBhKonLJRtQziXkbEGkHL+w9FMi9+iLvnw=";

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
