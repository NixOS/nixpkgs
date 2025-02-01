{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "hextazy";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "0xfalafel";
    repo = "hextazy";
    rev = "${version}";
    hash = "sha256-unZAW5ErHaEPpPwlo20/3//qhTpCjcmj0ses9FKgVJc=";
  };

  cargoHash = "sha256-4JpgUGthCbXSn98f4RrPoTcaGSCyZeuJqMVdLH7gKgs=";

  meta = {
    description = "TUI hexeditor in Rust with colored bytes";
    homepage = "https://github.com/0xfalafel/hextazy";
    changelog = "https://github.com/0xfalafel/hextazy/releases/tags/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ akechishiro ];
    mainProgram = "hextazy";
  };
}
