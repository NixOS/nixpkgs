{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gore";
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "motemen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-x8iIPu5BsXw47+sIqFjlk/3IXwL+MBXb3UPbZLcMUKQ=";
  };

  vendorHash = "sha256-TW25H0xH+BlWpeYkIRPUGWkkvFgsowQJbUHlxbc1F1I=";

  doCheck = false;

  meta = with lib; {
    description = "Yet another Go REPL that works nicely";
    mainProgram = "gore";
    homepage = "https://github.com/motemen/gore";
    license = licenses.mit;
    maintainers = with maintainers; [ offline ];
  };
}
