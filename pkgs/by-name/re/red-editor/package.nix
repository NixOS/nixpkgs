{
  lib,
  fetchFromGitHub,
  gitMinimal,
  makeWrapper,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "red-editor";
  version = "0.12.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "codersauce";
    repo = "red";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f2D3vN+NYOVMfHAnoOOihRM++dv1KjoJ6ivIlMswAkw=";
  };

  cargoHash = "sha256-v45W3bAlgIZGkjUUpRQUlI/T2JhmWrc7bpblbGqi+w0=";

  cargoBuildFlags = [
    "--package"
    "red"
    "--bin"
    "red"
  ];

  # The full suite drives terminals and language servers; the self-check test
  # covers the bundled plugin runtime without them.
  cargoTestFlags = [
    "--package"
    "red"
    "--test"
    "self_check"
  ];

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [ gitMinimal ];

  # `red` is taken by the Red programming language and by GNU ed.
  postInstall = ''
    mv $out/bin/red $out/bin/red-editor
    wrapProgram $out/bin/red-editor \
      --suffix PATH : ${lib.makeBinPath [ gitMinimal ]}
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  postInstallCheck = ''
    export HOME=$(mktemp -d)
    cd $HOME
    NO_COLOR=1 $out/bin/red-editor --self-check | tail -n 1 | grep -Fx "red self-check ok"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modal terminal text editor with built-in Husk plugins";
    homepage = "https://getred.dev";
    changelog = "https://github.com/codersauce/red/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fcoury ];
    mainProgram = "red-editor";
    platforms = lib.platforms.unix;
  };
})
