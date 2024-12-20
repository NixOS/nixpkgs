{
  lib,
  fetchFromGitHub,
  rustPlatform,
  git,
}:
let
  version = "0.3.0";
in
rustPlatform.buildRustPackage {
  pname = "gitprompt-rs";
  inherit version;

  src = fetchFromGitHub {
    owner = "9ary";
    repo = "gitprompt-rs";
    rev = version;
    hash = "sha256-BqI3LbG7I/0wjzJaP8bxRwTM56joLqVaQCmAydX5vQM=";
  };

  cargoHash = "sha256-KBBdhiXEZz1/w6Zr/LogyceBdCn1ebfkVgGbtcdAeis=";

  postPatch = ''
    substituteInPlace src/main.rs \
      --replace 'Command::new("git")' 'Command::new("${git}/bin/git")'
  '';

  meta = {
    description = "Simple Git prompt";
    homepage = "https://github.com/9ary/gitprompt-rs";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      isabelroses
      cafkafk
    ];
    mainProgram = "gitprompt-rs";
  };
}
