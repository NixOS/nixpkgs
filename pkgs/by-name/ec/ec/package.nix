{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
  makeWrapper,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "ec";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "chojs23";
    repo = "ec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vpl9Gz/DVjdplx80oQsTbH2hTS/3Y7dKZw4x52V6wJU=";
  };

  vendorHash = "sha256-bV5y8zKculYULkFl9J95qebLOzdTT/LuYycqMmHKZ+g=";

  postPatch = ''
    substituteInPlace cmd/ec/main.go \
      --replace-fail \
        'var version = "dev"' \
        'var version = "${finalAttrs.version}"'
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [ git ];

  postInstall = ''
    wrapProgram $out/bin/ec --prefix PATH : ${
      lib.makeBinPath [
        git
      ]
    }
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Easy terminal-native 3-way git conflict resolver vim-like workflow";
    homepage = "https://github.com/chojs23/ec";
    changelog = "https://github.com/chojs23/ec/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "ec";
  };
})
