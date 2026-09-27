{
  lib,
  fetchFromGitHub,
  rustPlatform,
  writableTmpDirAsHomeHook,
  gitMinimal,
  gh,
  makeWrapper,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "octorus";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "ushironoko";
    repo = "octorus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qwWCH/Yu9idxaOMNMlSM/RTJgSkpFSyV8VcmnK7DTqI=";
  };

  cargoHash = "sha256-wFPeBzbR+/n4gd0y15ToN2XRfsxsCu9if+XT6UTa1GI=";

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  postInstall = ''
    wrapProgram $out/bin/or \
      --prefix PATH : ${
        lib.makeBinPath [
          gh
          gitMinimal
        ]
      }
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "TUI PR review tool for GitHub";
    homepage = "https://github.com/ushironoko/octorus";
    changelog = "https://github.com/ushironoko/octorus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      kangazero
    ];
    mainProgram = "or";
  };
})
