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
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "Julien-cpsn";
    repo = "ATAC";
    rev = "v${finalAttrs.version}";
    hash = "sha256-P/m0iDXRymx2fCh11TdryvCFcsE2xxArpcacCty/kWs=";
  };

  cargoHash = "sha256-h3mOVYvtXPpu2zRgKtvFSQe4BSzXm0RreUgwExvL+fI=";

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
