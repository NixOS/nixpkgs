{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
  installShellFiles,
  writableTmpDirAsHomeHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "atac";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "Julien-cpsn";
    repo = "ATAC";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2z0+6CyVJR6sTFHotegCU8+isDy4Pw+gkJ1eUBs+AYM=";
  };

  cargoHash = "sha256-lJO9riP/3FRrQ/gkKQCghfkNn1ePS+p6FtMcJTIJxZY=";

  nativeBuildInputs = [
    installShellFiles
    writableTmpDirAsHomeHook
    pkg-config
  ];

  buildInputs = [ oniguruma ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  postInstall = ''
    $out/bin/atac completions bash
    $out/bin/atac completions fish
    $out/bin/atac completions zsh
    installShellCompletion --cmd atac \
      --bash atac.bash \
      --fish atac.fish \
      --zsh _atac

    mkdir -p $out/share/powershell
    $out/bin/atac completions powershell $out/share/powershell

    $out/bin/atac man
    installManPage atac.1
  '';

  meta = {
    description = "Simple API client (postman like) in your terminal";
    homepage = "https://github.com/Julien-cpsn/ATAC";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vinnymeller ];
    mainProgram = "atac";
  };
})
