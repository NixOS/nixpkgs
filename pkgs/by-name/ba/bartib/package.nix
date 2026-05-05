{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bartib";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "nikolassv";
    repo = "bartib";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-eVLacxKD8seD8mxVN1D3HhKZkIDXsEsSisZnFbmhpSk=";
  };

  cargoHash = "sha256-OSnBcYeTH9UqAXGhT/seEfNBejbYj/FTiMwMbvY7Bf4=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd bartib --bash misc/bartibCompletion.sh
    installShellCompletion --cmd bartib --fish misc/bartib.fish
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple timetracker for the command line";
    homepage = "https://github.com/nikolassv/bartib";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.progrm_jarvis ];
    mainProgram = "bartib";
  };
})
