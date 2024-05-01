{
  lib,
  fetchFromGitHub,
  rustPlatform,
  git,
}:
rustPlatform.buildRustPackage rec {
  pname = "gitprompt-rs";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "9ary";
    repo = pname;
    rev = version;
    hash = "sha256-BqI3LbG7I/0wjzJaP8bxRwTM56joLqVaQCmAydX5vQM=";
  };

  cargoHash = "sha256-KBBdhiXEZz1/w6Zr/LogyceBdCn1ebfkVgGbtcdAeis=";

  postPatch = ''
    substituteInPlace src/main.rs \
      --replace 'Command::new("git")' 'Command::new("${git}/bin/git")'
  '';

  meta = with lib; {
    description = "Simple Git prompt";
    homepage = "https://github.com/9ary/gitprompt-rs";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ isabelroses cafkafk ];
    mainProgram = "gitprompt-rs";
  };
}
