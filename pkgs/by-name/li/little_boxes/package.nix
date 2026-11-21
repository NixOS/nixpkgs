{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "little_boxes";
  version = "1.13.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "giodamelio";
    repo = "little_boxes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RRjIB5P159snYV9WbwBw67qAHEEkPXKoP7s0m9JkTe4=";
  };

  cargoVendorDir = "vendor";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    extrasPath=$(ls -d $releaseDir/build/little_boxes-*/out/)

    installManPage $extrasPath/little_boxes.1
    installShellCompletion --bash $extrasPath/little_boxes.bash
    installShellCompletion --fish $extrasPath/little_boxes.fish
    installShellCompletion --zsh $extrasPath/_little_boxes
    installShellCompletion --nushell $extrasPath/little_boxes.nu
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Add boxes are input text";
    longDescription = ''
      little_boxes is a small program that takes input from stdin or a file
      and wraps it with box made of ACII/Unicode Box Drawing characters. There
      are several different charsets and you can optionally add a title

      Example:

      $ echo "Hello World" | little_boxes
      ┏━━━━━━━━━━━━━┓
      ┃ Hello World ┃
      ┗━━━━━━━━━━━━━┛
    '';
    homepage = "https://github.com/giodamelio/little_boxes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ giodamelio ];
    mainProgram = "little_boxes";
  };
})
