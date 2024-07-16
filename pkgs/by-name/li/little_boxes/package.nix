{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, versionCheckHook
}:

rustPlatform.buildRustPackage rec {
  pname = "little_boxes";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "giodamelio";
    repo = "little_boxes";
    rev = version;
    hash = "sha256-Quh09K5meiA39ih/orJWF2WfkuZdymxub1dZvns/q3E=";
  };

  cargoVendorDir = "vendor";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    extrasPath=$(ls -d $releaseDir/build/little_boxes-*/out/)

    installManPage $extrasPath/little_boxes.1
    installShellCompletion --bash $extrasPath/little_boxes.bash
    installShellCompletion --fish $extrasPath/little_boxes.fish
    installShellCompletion --zsh $extrasPath/_little_boxes
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = with lib; {
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
    license = licenses.mit;
    maintainers = with maintainers; [ giodamelio ];
    mainProgram = "little_boxes";
  };
}
