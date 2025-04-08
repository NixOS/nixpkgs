{
  lib,
  fetchFromGitHub,
  rustPlatform,
  git,
}:
let
  version = "0.4.1";
in
rustPlatform.buildRustPackage {
  pname = "gitprompt-rs";
  inherit version;

  src = fetchFromGitHub {
    owner = "9ary";
    repo = "gitprompt-rs";
    rev = version;
    hash = "sha256-U0ylhgD86lbXvt6jMLaEQdL/zbcbXnfrA72FMEzBkN0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1ihTH/Ft9/8wjRRR0Mt3m8AUYvUEARzdr+R77LjSxzY=";

  postPatch = ''
    substituteInPlace src/main.rs \
      --replace 'Command::new("git")' 'Command::new("${git}/bin/git")'
  '';

  meta = {
    description = "Simple Git prompt";
    homepage = "https://github.com/9ary/gitprompt-rs";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [
      isabelroses
      cafkafk
    ];
    mainProgram = "gitprompt-rs";
  };
}
