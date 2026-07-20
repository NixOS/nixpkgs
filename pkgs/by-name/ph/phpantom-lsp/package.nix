{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  _experimental-update-script-combinators,
  nix-update-script,
}:

let
  stubsSrc = fetchFromGitHub {
    owner = "JetBrains";
    repo = "phpstorm-stubs";
    rev = "517b9ad1adaf2c5453c00ec2fbb02d192a4a9b6c";
    hash = "sha256-IDWAuy301avfTF/E7Mby2JQQtIr/gnN5flZ3uctUpus=";
  };
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "phpantom-lsp";
  version = "0.8.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AJenbo";
    repo = "phpantom_lsp";
    tag = finalAttrs.version;
    hash = "sha256-00NAiPm3qqxyS1u1GPpJlgnBlUjDx9VmjK6oOwH8kcU=";
  };

  postPatch = ''
    mkdir -p stubs/jetbrains
    cp -a ${finalAttrs.passthru.stubsSrc} stubs/jetbrains/phpstorm-stubs
    chmod u+wx stubs/jetbrains/phpstorm-stubs

    echo "${finalAttrs.passthru.stubsSrc.rev}" \
      > stubs/jetbrains/phpstorm-stubs/.commit
  '';

  cargoHash = "sha256-FyMI8Kb3QUD8Jui9k7vayMcQC+KWL8sZi3A05NPbXsg=";

  checkFlags = [
    "--test"
    "completion_inheritance"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    inherit stubsSrc;
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      ./update-php-stubs.sh
    ];
  };

  meta = {
    changelog = "https://github.com/AJenbo/phpantom_lsp/releases/tag/${finalAttrs.src.tag}";
    description = "Fast, lightweight PHP language server written in Rust";
    homepage = "https://github.com/AJenbo/phpantom_lsp";
    license = lib.licenses.mit;
    mainProgram = "phpantom_lsp";
    maintainers = with lib.maintainers; [ nanoyaki ];
  };
})
