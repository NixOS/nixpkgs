{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gore";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "motemen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-J6rXz62y/qj4GFXnUwpfx9UEUQaUVQjf7KQCSzmNsws=";
  };

  vendorHash = "sha256-MpmDQ++32Rop1yYcibEr7hQJ7YAU1QvITzTSstL5V9w=";

  doCheck = false;

  meta = with lib; {
    description = "Yet another Go REPL that works nicely";
    mainProgram = "gore";
    homepage = "https://github.com/motemen/gore";
    license = licenses.mit;
    maintainers = with maintainers; [ offline ];
  };
}
