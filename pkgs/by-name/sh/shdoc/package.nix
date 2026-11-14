{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gawk,
  versionCheckHook,
  nix-update-script,
  installShellFiles,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "shdoc";
  version = "1.4";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "reconquest";
    repo = "shdoc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jJSSN9rVKsYkqCABFdtW3W3hDNfivhR+Y6axjbexwds=";
  };

  buildInputs = [ gawk ];
  nativeBuildInputs = [
    installShellFiles
  ];

  postPatch = ''
    # Skip tests
    # Upstream takes from submodule "import.bash", of which the script imports another submodule "test-runner.bash"
    # See https://github.com/reconquest/import.bash/blob/b8d543eadad8fc21b80e512aff83f2c7502e9ef0/import.bash#L29-L51
    substituteInPlace Makefile \
      --replace-fail "include vendor/github.com/reconquest/test-runner.bash/Makefile" ""

    patchShebangs shdoc
  '';

  installPhase = ''
    runHook preInstall

    install -Dm555 shdoc -t $out/bin
    installManPage contrib/shdoc.1

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Javadoc documentation generator for shell scripts (bash, sh, zsh)";
    homepage = "https://github.com/reconquest/shdoc";
    changelog = "https://github.com/reconquest/shdoc/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "shdoc";
    maintainers = with lib.maintainers; [ kangazero ];
    platforms = gawk.meta.platforms;
  };
})
