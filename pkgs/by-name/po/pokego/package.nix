{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "pokego";
  version = "0.5.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rubiin";
    repo = "pokego";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GBKQ9YV98znhTP9QsvAAyva8dNohFS8dbQ4FAG5IDig=";
  };

  vendorHash = "sha256-a/YYEMVCqyg76P2Pyfpej46vYQhnnJjicpxNMAZGOVg=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion completions/pokego.bash
    installShellCompletion completions/pokego.fish
    installShellCompletion completions/pokego.zsh
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Display Pokémon sprites in color directly in your terminal";
    homepage = "https://github.com/rubiin/pokego";
    license = lib.licenses.gpl3Only;
    mainProgram = "pokego";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ yvnth ];
  };
})
