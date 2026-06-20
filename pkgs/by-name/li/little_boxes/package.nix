{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  testers,
  little_boxes,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "little_boxes";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "giodamelio";
    repo = "little_boxes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ejFo+BYoXf889G/iLuKITwY3ephkEMS6nLtfi3PozHQ=";
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

  passthru.tests.version = testers.testVersion {
    package = little_boxes;
    command = "little_boxes --version";
  };

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
